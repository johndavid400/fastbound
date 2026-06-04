module Fastbound
  module Resources
    class Inventory
      def initialize(client)
        @client = client
      end

      def bulk_verify(serials:, rollback_partial: nil, update_location: nil,
                      location: nil, verified_utc: nil)
        @client.put("#{@client.base_path}/Inventory/BulkVerify", {
          serials: serials,
          rollbackPartial: rollback_partial,
          updateLocation: update_location,
          location: location,
          verifiedUtc: verified_utc
        }.reject { |_, v| v.nil? })
      end
    end
  end
end
