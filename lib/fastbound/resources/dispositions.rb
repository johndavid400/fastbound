module Fastbound
  module Resources
    class Dispositions
      def initialize(client)
        @client = client
      end

      def list(take: nil, skip: nil, include_4473: nil, id: nil, external_id: nil,
               type: nil, ttsn: nil, otsn: nil, purchase_order_number: nil,
               invoice_number: nil, shipment_tracking_number: nil,
               is_manufacturing_disposition: nil, disposed_to_contact_id: nil,
               disposed_to_contact_external_id: nil, item_id: nil, item_external_id: nil)
        @client.get("#{base}/Dispositions", {
          take: take, skip: skip, include4473: include_4473, id: id,
          externalId: external_id, type: type, TTSN: ttsn, OTSN: otsn,
          purchaseOrderNumber: purchase_order_number, invoiceNumber: invoice_number,
          shipmentTrackingNumber: shipment_tracking_number,
          isManufacturingDisposition: is_manufacturing_disposition,
          disposedToContactId: disposed_to_contact_id,
          disposedToContactExternalId: disposed_to_contact_external_id,
          itemId: item_id, itemExternalId: item_external_id
        })
      end

      def list_4473s(take: nil, skip: nil, include_awaiting_completion: nil)
        @client.get("#{base}/Dispositions/Only4473s", {
          take: take, skip: skip,
          includeAwaiting4473Completion: include_awaiting_completion
        })
      end

      def find(id)
        @client.get("#{base}/Dispositions/#{id}")
      end

      def find_by_external_id(external_id)
        @client.get("#{base}/Dispositions/GetByExternalId/#{external_id}")
      end

      def create(params = {})
        @client.post("#{base}/Dispositions", params)
      end

      def create_nfa(params = {})
        @client.post("#{base}/Dispositions/NFA", params)
      end

      def create_theft_loss(params = {})
        @client.post("#{base}/Dispositions/TheftLoss", params)
      end

      def create_destroyed(params = {})
        @client.post("#{base}/Dispositions/Destroyed", params)
      end

      def update(id, params = {})
        @client.put("#{base}/Dispositions/#{id}", params)
      end

      def destroy(id)
        @client.delete("#{base}/Dispositions/#{id}")
      end

      def attach_contact(id, contact_id)
        @client.put("#{base}/Dispositions/#{id}/AttachContact/#{contact_id}", {})
      end

      def lock(id)
        @client.put("#{base}/Dispositions/Lock/#{id}", {})
      end

      def lock_by_external_id(external_id)
        @client.put("#{base}/Dispositions/LockByExternalId/#{external_id}", {})
      end

      def commit(id, params = {}, list_disposed_items: nil)
        path = "#{base}/Dispositions/#{id}/Commit"
        path += "?listDisposedItems=true" if list_disposed_items
        @client.post(path, params)
      end

      def create_and_commit(params = {}, list_disposed_items: nil)
        path = "#{base}/Dispositions/CreateAndCommit"
        path += "?listDisposedItems=true" if list_disposed_items
        @client.post(path, params)
      end

      def create_as_pending(params = {})
        @client.post("#{base}/Dispositions/CreateAsPending", params)
      end

      # Item operations

      def list_items(id)
        @client.get("#{base}/Dispositions/#{id}/Items")
      end

      def add_items(id, items = [])
        @client.post("#{base}/Dispositions/#{id}/Items", { items: items })
      end

      def add_items_by_external_id(disposition_external_id, items = [])
        @client.post("#{base}/Dispositions/#{disposition_external_id}/Items/AddByExternalId", { items: items })
      end

      def add_items_by_search(disposition_external_id, params = {})
        @client.post("#{base}/Dispositions/#{disposition_external_id}/Items/AddBySearch", params)
      end

      def edit_item_price(id, item_id, price:)
        @client.put("#{base}/Dispositions/#{id}/Items/EditPrice/#{item_id}", { price: price })
      end

      def remove_item(id, item_id)
        @client.delete("#{base}/Dispositions/#{id}/Items/Remove/#{item_id}")
      end

      def remove_item_by_external_id(id, item_external_id)
        @client.delete("#{base}/Dispositions/#{id}/Items/RemoveByExternalId/#{item_external_id}")
      end

      private

      def base
        @client.base_path
      end
    end
  end
end
