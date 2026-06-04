module Fastbound
  module Resources
    class MultipleSaleReports
      def initialize(client)
        @client = client
      end

      def download(multiple_sale_report_id, attachment_id)
        @client.get_binary(
          "#{@client.base_path}/MultipleSaleReports/Download/#{multiple_sale_report_id}/a/#{attachment_id}"
        )
      end
    end
  end
end
