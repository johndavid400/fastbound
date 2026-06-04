module Fastbound
  module Resources
    class SmartLists
      def initialize(client)
        @client = client
      end

      def acquire_types
        @client.get("#{base}/SmartLists/AcquireType")
      end

      def calibers
        @client.get("#{base}/SmartLists/Caliber")
      end

      def conditions
        @client.get("#{base}/SmartLists/Condition")
      end

      def countries_of_manufacture
        @client.get("#{base}/SmartLists/CountryOfManufacture")
      end

      def delete_types
        @client.get("#{base}/SmartLists/DeleteType")
      end

      def dispose_types
        @client.get("#{base}/SmartLists/DisposeType")
      end

      def importers
        @client.get("#{base}/SmartLists/Importer")
      end

      def item_types
        @client.get("#{base}/SmartLists/ItemType")
      end

      def license_types
        @client.get("#{base}/SmartLists/LicenseType")
      end

      def locations
        @client.get("#{base}/SmartLists/Location")
      end

      def manufacturers
        @client.get("#{base}/SmartLists/Manufacturer")
      end

      def theft_loss_types
        @client.get("#{base}/SmartLists/TheftLossType")
      end

      def manufacturing_dispose_types
        @client.get("#{base}/SmartLists/ManufacturingDisposeType")
      end

      def manufacturing_acquire_types
        @client.get("#{base}/SmartLists/ManufacturingAcquireType")
      end

      private

      def base
        @client.base_path
      end
    end
  end
end
