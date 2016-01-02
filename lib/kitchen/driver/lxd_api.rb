# -*- encoding: utf-8 -*-

require 'kitchen'
require 'oreno_lxdapi'

module Kitchen

  module Driver

    #
    # LxdApi driver for Kitchen.
    # Be unrefined!!!!!!!! :-<
    #

    class LxdApi < Kitchen::Driver::Base
      kitchen_driver_api_version 2

      # default: unix:///var/lib/lxd/unix.socket
      default_config :uri, "unix:///var/lib/lxd/unix.socket"

      default_config :container_image, nil
      default_config :container_name, nil
      default_config :username, "root"
      default_config :public_key_path, "#{ENV["HOME"]}/.ssh/id_rsa.pub"
      default_config :authorized_keys_path, "/.ssh/authorized_keys"


      def create(state)

        # config[:architecture] = 2
        # config[:profiles] = ["default"]
        # config[:ephemeral] = true
        # config[:limits_cpu] = "1"
        #
        puts "Create Container..."
        container.create_container(
          :architecture => config[:architecture],
          :profiles => config[:profiles],
          :ephemeral => config[:ephemeral],
          :limits_cpu => config[:limits_cpu]
        )

        sleep 5

        # config[:timeout] = 30
        # config[:force] = true
        # 
        puts "Run Container..."
        container.state_container("start", :timeout => config[:timeout], :force => config[:force])

        puts "Set Username and Upload Public key..."
        unless config[:username] == "root"
          create_user 
        end
        state[:username] = config[:username]
        container.run_lxc_exec("mkdir #{set_user_home_dir_path(state[:username])}/.ssh")
        container.file_upload(config[:public_key_path], set_ssh_authorized_keys_path(state[:username]))

        puts "Change Permission..."
        container.run_lxc_exec("chown -R #{state[:username]}:#{state[:username]} #{set_user_home_dir_path(state[:username])}/.ssh")
        container.run_lxc_exec("chmod 700 #{set_user_home_dir_path(state[:username])}/.ssh")
        container.run_lxc_exec("chmod 600 #{set_ssh_authorized_keys_path(state[:username])}")

        puts "Describe Container..."
        metadata = container.describe_container
        state[:state] = metadata['status']['status']
        state[:ephemeral] = metadata['ephemeral'].to_s
        metadata['status']['ips'].each { |ip| state[:hostname] = ip['address'] if ip['interface'] == "eth0" }
      end

      def destroy(state)

        # config[:timeout] = 30
        # config[:force] = true
        # 
        puts "Destroy Container..."
        if state[:ephemeral] == "true"
          container.state_container("stop", :timeout => config[:timeout], :force => config[:force])
        elsif state[:ephemeral] == "false"
          container.state_container("stop", :timeout => config[:timeout], :force => config[:force])
          container.delete_container
        end
      end

      private

      def container
        OrenoLxdapi::Client.new(config[:uri], config[:container_image], config[:container_name]) 
      end
      
      def set_ssh_authorized_keys_path(username)
        if username == "root"
          return "/root" + "#{config[:authorized_keys_path]}"
        else
          return "/home/#{username}" + "#{config[:authorized_keys_path]}"
        end
      end

      def set_user_home_dir_path(username)
        if username == "root"
          return "/root"
        else
          return "/home/#{username}"
        end
      end

      def create_user
        container.run_lxc_exec("useradd -m -G sudo #{config[:username]} -s /bin/bash")
        container.run_lxc_exec("sh -c \"echo '#{config[:username]} ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers\"")
      end

    end
  end
end
