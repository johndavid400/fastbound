module Fastbound
  module Resources
    class Acquisitions
      def initialize(client)
        @client = client
      end

      def list(take: nil, skip: nil, id: nil, external_id: nil, type: nil,
               purchase_order_number: nil, invoice_number: nil,
               shipment_tracking_number: nil, is_manufacturing_acquisition: nil,
               acquired_from_contact_id: nil, acquired_from_contact_external_id: nil,
               item_id: nil, item_external_id: nil)
        @client.get("#{base}/Acquisitions", {
          take: take, skip: skip, id: id, externalId: external_id, type: type,
          purchaseOrderNumber: purchase_order_number, invoiceNumber: invoice_number,
          shipmentTrackingNumber: shipment_tracking_number,
          isManufacturingAcquisition: is_manufacturing_acquisition,
          acquiredFromContactId: acquired_from_contact_id,
          acquiredFromContactExternalId: acquired_from_contact_external_id,
          itemId: item_id, itemExternalId: item_external_id
        })
      end

      def find(id)
        @client.get("#{base}/Acquisitions/#{id}")
      end

      def find_by_external_id(external_id)
        @client.get("#{base}/Acquisitions/GetByExternalId/#{external_id}")
      end

      def create(params = {})
        @client.post("#{base}/Acquisitions", params)
      end

      def update(id, params = {})
        @client.put("#{base}/Acquisitions/#{id}", params)
      end

      def destroy(id)
        @client.delete("#{base}/Acquisitions/#{id}")
      end

      def attach_contact(id, contact_id)
        @client.put("#{base}/Acquisitions/#{id}/AttachContact/#{contact_id}", {})
      end

      def commit(id, params = {}, list_acquired_items: nil)
        path = "#{base}/Acquisitions/#{id}/Commit"
        path += "?listAcquiredItems=true" if list_acquired_items
        @client.post(path, params)
      end

      def create_and_commit(params = {}, list_acquired_items: nil)
        path = "#{base}/Acquisitions/CreateAndCommit"
        path += "?listAcquiredItems=true" if list_acquired_items
        @client.post(path, params)
      end

      def create_as_pending(params = {})
        @client.post("#{base}/Acquisitions/CreateAsPending", params)
      end

      # Item operations

      def get_item(id, acquisition_item_id)
        @client.get("#{base}/Acquisitions/#{id}/Items/#{acquisition_item_id}")
      end

      def get_item_by_external_ids(acquisition_external_id, acquisition_item_external_id)
        @client.get("#{base}/Acquisitions/#{acquisition_external_id}/Items/#{acquisition_item_external_id}")
      end

      def add_item(id, params = {})
        @client.post("#{base}/Acquisitions/#{id}/Items", params)
      end

      def add_items(id, items = [])
        @client.post("#{base}/Acquisitions/#{id}/Items/Multiple", { items: items })
      end

      def update_item(id, acquisition_item_id, params = {})
        @client.put("#{base}/Acquisitions/#{id}/Items/#{acquisition_item_id}", params)
      end

      def delete_item(id, acquisition_item_id)
        @client.delete("#{base}/Acquisitions/#{id}/Items/#{acquisition_item_id}")
      end

      private

      def base
        @client.base_path
      end
    end
  end
end
