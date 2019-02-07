class Engine < ::Rails::Engine
  engine_name 'fedscope'
  # isolate_namespace Kms::Api
  config.eager_load_paths += Dir["#{config.root}/lib/**/"]
  config.to_prepare do
    Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
      require_dependency(c)
    end
  end

  # initializer "kms_api.register_api_collections" do |app|
  #   app.config.after_initialize do
  #     Kms::Api.pluck(:collection_name).each do |collection_name|
  #       Kms::ApiWrapperDrop.register_api collection_name
  #     end if Kms::Api.table_exists?
  #   end
  # end
end
