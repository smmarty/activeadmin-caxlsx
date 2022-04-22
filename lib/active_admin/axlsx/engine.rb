module ActiveAdmin
  module Axlsx
    # Extends ActiveAdmin with xlsx downloads
    class Engine < ::Rails::Engine
      engine_name 'active_admin_xlsx'

      initializer 'active_admin.xlsx', group: :all do
        if Mime::Type.lookup_by_extension(:xlsx).nil?
          # The mime type to be used in respond_to |format| style web-services in rails
          Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
        end

        ActiveAdmin::Views::PaginatedCollection.add_format :xlsx

        ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Axlsx::DSL
        ActiveAdmin::Resource.send :include, ActiveAdmin::Axlsx::ResourceExtension
        ActiveSupport.on_load(:after_initialize) do
          ActiveAdmin::ResourceController.send(
            :prepend,
            ActiveAdmin::Axlsx::ResourceControllerExtension
          )
        end
      end
    end
  end
end
