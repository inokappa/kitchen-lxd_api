# -*- encoding: utf-8 -*-

require 'kitchen'
require 'oreno_lxdapi'

module Kitchen

  module Driver

    # LxdApi driver for Kitchen.
    #
    # @author TODO: Write your name <inokara at gmail.com>
    class LxdApi < Kitchen::Driver::SSHBase

      # default: unix:///var/lib/lxd/unix.socket
      default_config :uri, "unix:///var/lib/lxd/unix.socket"

      default_config :container_image, nil
      default_config :container_name, nil
      default_config :username, "root"
      default_config :public_key_path, "#{ENV["HOME"]}/.ssh/id_rsa.pub"
      default_config :authorized_keys_path, "/.ssh/authorized_keys"

      def container
        OrenoLxdapi::Client.new(config[:uri], config[:container_image], config[:container_name]) 
      end

      def create(state)
        puts "Create Container..."
        container.create_container

        sleep 5

        puts "Run Container..."
        container.run_container

        puts "Upload Public key..."
        container.run_lxc_exec("mkdir #{create_user(config[:username])}/.ssh")
        container.file_upload(config[:public_key_path], create_ssh_authorized_keys_path(config[:username]))

        puts "Change Permission..."
        container.run_lxc_exec("chmod 700 #{create_user(config[:username])}/.ssh")
        container.run_lxc_exec("chmod 600 #{create_ssh_authorized_keys_path(config[:username])}")

        puts "Get Container IP address..."
        state[:hostname] = container.check_container_status[1]
      end

      def destroy(state)
        puts "Destroy Container..."
        container.stop_container
      end

      private
      
      def create_ssh_authorized_keys_path(username)
        if username == "root"
          return "/root" + "#{config[:authorized_keys_path]}"
        else
          return "/home/#{username}" + "#{config[:authorized_keys_path]}"
        end
      end

      def create_user(username)
        if username == "root"
          return "/root"
        else
          return "/home/#{username}"
        end
      end

    end
  end
end
