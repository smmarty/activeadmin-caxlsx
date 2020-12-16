module ActiveAdmin
  module Caxlsx
    module ResourceExtension
      def xlsx_builder=(builder)
        @xlsx_builder = builder
      end

      def xlsx_builder
        @xlsx_builder ||= ActiveAdmin::Caxlsx::Builder.new(resource_class)
      end
    end
  end
end
