# frozen_string_literal: true

require "sidekiq"
require "sidekiq/api"
require_relative "sidekiq_liveness/server"
require_relative "sidekiq_liveness/version"

module SidekiqLiveness
  def self.start
    Sidekiq.configure_server do |config|
      config.on(:startup) do
        @server_pid = fork do
          SidekiqLiveness::Server.run!
        end
      end

      config.on(:shutdown) do
        Process.kill("TERM", @server_pid) unless @server_pid.nil?
        Process.wait(@server_pid) unless @server_pid.nil?
      end
    end
  end

  def self.alive?
    # Find current process if exists
    process = Sidekiq::ProcessSet.new.find { |p| p["pid"] == ::Process.ppid }
    return false unless process

    process["beat"] > (Time.now.to_i - 15)
  end
end
