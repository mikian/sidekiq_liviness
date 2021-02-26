# frozen_string_literal: true

require "rack"

module SidekiqLiveness
  class Server
    class << self
      def run!
        handler = Rack::Handler.get("webrick")

        Signal.trap("TERM") { handler.shutdown }

        handler.run(self, Port: port, Host: "0.0.0.0")
      end

      def call(env)
        if Rack::Request.new(env).path != path
          [404, {}, [""]]
        elsif SidekiqLiveness.alive?
          [200, {}, [""]]
        else
          [500, {}, [""]]
        end
      end

      private

      def port
        ENV.fetch("SIDEKIQ_LIVENESS_PORT") { 7433 }
      end

      def path
        ENV.fetch("SIDEKIQ_LIVENESS_PATH") { "/healthz" }
      end
    end
  end
end
