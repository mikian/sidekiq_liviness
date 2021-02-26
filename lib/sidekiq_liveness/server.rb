# frozen_string_literal: true

require "rack"

module SidekiqLiveness
  class Server
    class << self
      def run!
        handler = Rack::Handler.get("webrick")

        Signal.trap("TERM") { handler.shutdown }

        handler.run(self, Port: port, Host: host)
      end

      def call(env)
        case Rack::Request.new(env).path
        when "/healthz"
          [SidekiqLiveness.alive? ? 200 : 500, {}, [""]]
        when "/stop"
          SidekiqLiveness.stop!
          [200, {}, [""]]
        else
          [404, {}, [""]]
        end
      end

      private

      def port
        ENV.fetch("SIDEKIQ_LIVENESS_PORT") { 7433 }
      end

      def host
        ENV.fetch("SIDEKIQ_LIVENESS_HOST") { "0.0.0.0" }
      end
    end
  end
end
