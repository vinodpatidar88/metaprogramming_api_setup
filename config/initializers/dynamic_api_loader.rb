module DynamicAPI
  def self.load_services
    Dir[Rails.root.join("app/services/*")].each do |model_folder|

      model = File.basename(model_folder)
      model_class = model.singularize.camelize
      controller_name = "#{model.camelize}Controller"

      # IMPORTANT FIX
      controller_class = Class.new(ApplicationController)

      Dir[File.join(model_folder, "*.rb")].each do |file|
        service_class_name = File.basename(file, ".rb").camelize
        action = File.basename(file, ".rb").split("_").first

        controller_class.define_method(action) do
          service = "#{model.capitalize}::#{service_class_name}".constantize

          begin
            result = service.new(permitted_params).call

            status_code =
              case action
              when "create"
                :created
              when "delete", "destroy"
                :no_content
              else
                :ok
              end

            render json: result, status: status_code

          rescue ActiveRecord::RecordNotFound => e
            render json: { error: e.message }, status: :not_found

          rescue ActiveRecord::RecordInvalid => e
            render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity

          rescue ActionController::ParameterMissing => e
            render json: { error: e.message }, status: :bad_request

          rescue StandardError => e
            render json: { error: e.message }, status: :internal_server_error
          end
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