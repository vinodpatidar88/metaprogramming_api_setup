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

            begin
              result =
                case action
                when "create"
                  service.new(params.permit(*permitted_keys.push(:password, :password_confirmation, :limit, :page))).call

                when "list"
                  service.new(params).call

                when "show"
                  service.new(params[:id]).call

                when "update"
                  service.new(params[:id], params.permit(*permitted_keys)).call

                when "delete"
                  service.new(params[:id]).call

                else
                  service.new(params.permit(*permitted_keys)).call
                end

              status_code =
                case action
                when "create"
                  :created
                when "delete"
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