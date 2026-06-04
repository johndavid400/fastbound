module Fastbound
  module Resources
    class Downloads
      def initialize(client)
        @client = client
      end

      def bound_book(params = {})
        @client.post_binary("#{@client.base_path}/Downloads/BoundBook", params)
      end
    end
  end
end
