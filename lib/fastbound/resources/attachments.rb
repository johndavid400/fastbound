module Fastbound
  module Resources
    class Attachments
      def initialize(client)
        @client = client
      end

      def download(attachment_id)
        @client.get_binary("#{@client.base_path}/Attachments/Download/#{attachment_id}")
      end
    end
  end
end
