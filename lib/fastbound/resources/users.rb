module Fastbound
  module Resources
    class Users
      def initialize(client)
        @client = client
      end

      def list(include_disabled: nil)
        @client.get("#{@client.base_path}/Users", { IncludeDisabled: include_disabled })
      end
    end
  end
end
