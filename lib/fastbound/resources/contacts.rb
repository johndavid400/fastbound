module Fastbound
  module Resources
    class Contacts
      def initialize(client)
        @client = client
      end

      def list(license_name: nil, trade_name: nil, ffl_number: nil,
               organization_name: nil, first_name: nil, middle_name: nil,
               last_name: nil, suffix: nil, take: nil, skip: nil)
        @client.get("#{base}/Contacts", {
          licenseName: license_name, tradeName: trade_name, fflNumber: ffl_number,
          organizationName: organization_name, firstName: first_name,
          middleName: middle_name, lastName: last_name, suffix: suffix,
          take: take, skip: skip
        })
      end

      def find(id)
        @client.get("#{base}/Contacts/#{id}")
      end

      def find_by_external_id(external_id)
        @client.get("#{base}/Contacts/GetByExternalId/#{external_id}")
      end

      def create(params = {})
        @client.post("#{base}/Contacts", params)
      end

      def update(id, params = {})
        @client.put("#{base}/Contacts/#{id}", params)
      end

      def destroy(id)
        @client.delete("#{base}/Contacts/#{id}")
      end

      def merge(winning_contact_id:, losing_contact_id:)
        @client.post("#{base}/Contacts/Merge", {
          winningContactId: winning_contact_id,
          losingContactId: losing_contact_id
        })
      end

      # License operations

      def get_license(id, license_id)
        @client.get("#{base}/Contacts/#{id}/Licenses/#{license_id}")
      end

      def create_license(id, params = {})
        @client.post("#{base}/Contacts/#{id}/Licenses", params)
      end

      def update_license(id, license_id, params = {})
        @client.put("#{base}/Contacts/#{id}/Licenses/#{license_id}", params)
      end

      def delete_license(id, license_id)
        @client.delete("#{base}/Contacts/#{id}/Licenses/#{license_id}")
      end

      private

      def base
        @client.base_path
      end
    end
  end
end
