module Fastbound
  module Resources
    class Items
      def initialize(client)
        @client = client
      end

      def list(search: nil, item_number: nil, serial: nil, manufacturer: nil,
               importer: nil, model: nil, type: nil, caliber: nil, location: nil,
               condition: nil, mpn: nil, upc: nil, sku: nil, is_theft_loss: nil,
               is_destroyed: nil, do_not_dispose: nil, disposition_id: nil,
               status: nil, acquired_on_or_after: nil, acquired_on_or_before: nil,
               acquire_purchase_order_number: nil, acquire_invoice_number: nil,
               acquire_shipment_tracking_number: nil, disposed_on_or_after: nil,
               disposed_on_or_before: nil, dispose_purchase_order_number: nil,
               dispose_invoice_number: nil, dispose_shipment_tracking_number: nil,
               has_external_id: nil, acquisition_type: nil, ttsn: nil, otsn: nil,
               take: nil, skip: nil)
        @client.get("#{base}/Items", {
          search: search, itemNumber: item_number, serial: serial,
          manufacturer: manufacturer, importer: importer, model: model,
          type: type, caliber: caliber, location: location, condition: condition,
          mpn: mpn, upc: upc, sku: sku, isTheftLoss: is_theft_loss,
          isDestroyed: is_destroyed, doNotDispose: do_not_dispose,
          dispositionId: disposition_id, status: status,
          acquiredOnOrAfter: acquired_on_or_after,
          acquiredOnOrBefore: acquired_on_or_before,
          acquirePurchaseOrderNumber: acquire_purchase_order_number,
          acquireInvoiceNumber: acquire_invoice_number,
          acquireShipmentTrackingNumber: acquire_shipment_tracking_number,
          disposedOnOrAfter: disposed_on_or_after,
          disposedOnOrBefore: disposed_on_or_before,
          disposePurchaseOrderNumber: dispose_purchase_order_number,
          disposeInvoiceNumber: dispose_invoice_number,
          disposeShipmentTrackingNumber: dispose_shipment_tracking_number,
          hasExternalId: has_external_id, acquisitionType: acquisition_type,
          ttsn: ttsn, otsn: otsn, take: take, skip: skip
        })
      end

      def find(id)
        @client.get("#{base}/Items/#{id}")
      end

      def find_by_external_id(external_id)
        @client.get("#{base}/Items/GetByExternalId/#{external_id}")
      end

      def update(id, params = {})
        @client.put("#{base}/Items/#{id}", params)
      end

      def delete(id, delete_type:, delete_note: nil)
        @client.post("#{base}/Items/#{id}/Delete", {
          deleteType: delete_type,
          deleteNote: delete_note
        }.reject { |_, v| v.nil? })
      end

      def set_acquisition_contact(id, contact_id)
        @client.put("#{base}/Items/#{id}/AcquisitionContact/#{contact_id}", {})
      end

      def undispose(id, note: nil)
        body = note ? { note: note } : {}
        @client.put("#{base}/Items/#{id}/Undispose", body)
      end

      def set_external_id(id, external_id:)
        @client.put("#{base}/Items/#{id}/SetExternalId", { externalId: external_id })
      end

      def set_external_ids(items = [])
        @client.put("#{base}/Items/SetExternalIds", { items: items })
      end

      private

      def base
        @client.base_path
      end
    end
  end
end
