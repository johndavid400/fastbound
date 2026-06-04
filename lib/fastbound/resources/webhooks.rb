module Fastbound
  module Resources
    class Webhooks
      def initialize(client)
        @client = client
      end

      def list_events
        @client.get("#{base}/Webhooks/Events")
      end

      def find(name)
        @client.get("#{base}/Webhooks/#{name}")
      end

      def create(name:, url:, description: nil, events: [])
        @client.post("#{base}/Webhooks", {
          name: name, url: url, description: description, events: events
        }.reject { |_, v| v.nil? })
      end

      def update(name, url: nil, description: nil, events: nil)
        @client.put("#{base}/Webhooks/#{name}", {
          name: name, url: url, description: description, events: events
        }.reject { |_, v| v.nil? })
      end

      def destroy(name)
        @client.delete("#{base}/Webhooks/#{name}")
      end

      private

      def base
        @client.base_path
      end
    end
  end
end
