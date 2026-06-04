module Fastbound
  module Resources
    class Account
      def initialize(client)
        @client = client
      end

      def get
        @client.get("#{@client.base_path}/Account")
      end
    end
  end
end
