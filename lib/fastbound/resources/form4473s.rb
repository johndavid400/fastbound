module Fastbound
  module Resources
    class Form4473s
      def initialize(client)
        @client = client
      end

      def download(form4473_id)
        @client.get_binary("#{@client.base_path}/Form4473s/Download/#{form4473_id}")
      end
    end
  end
end
