module DynamicAPI
  def self.load_services
    Dir[Rails.root.join("app/services/*")].each do |model_folder|

      model = File.basename(model_folder)   # users
      model_class = model.singularize.camelize
      controller_name = "#{model.camelize}Controller"
      controller_class = Class.new(ActionController::API)
      Dir[File.join(model_folder, "*.rb")].each do |file|
        service_class_name = File.basename(file, ".rb").camelize
        action = File.basename(file, ".rb").split("_").first
        controller_class.define_method(action) do
          service = "Users::#{service_class_name}".constantize
          permitted_keys =
            if Object.const_defined?(model_class)
              model_class.constantize.column_names.map(&:to_sym)
            else
              params.keys
            end
          result =
            case action
            when "create"
              service.new.call(params.permit(*permitted_keys))

            when "list"
              service.new.call

            when "show"
              service.new.call(params[:id])

            when "update"
              service.new.call(params[:id], params.permit(*permitted_keys))

            when "delete"
              service.new.call(params[:id])

            else
              service.new.call(params.permit(*permitted_keys))
            end

          render json: result
        end
      end
      module_api = Object.const_defined?(:Api) ? Api : Object.const_set(:Api, Module.new)
      module_v1  = module_api.const_defined?(:V1) ? module_api::V1 : module_api.const_set(:V1, Module.new)

      module_v1.const_set(controller_name, controller_class)
    end
  end
end

Rails.application.config.to_prepare do
  DynamicAPI.load_services
end