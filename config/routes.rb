Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      Dir[Rails.root.join("app/services/*")].each do |model_folder|

        model = File.basename(model_folder)

        Dir[File.join(model_folder, "*.rb")].each do |file|

          action = File.basename(file, ".rb").split("_").first

          match "/#{model}/#{action}",
                to: "#{model}##{action}",
                via: [:get, :post, :patch, :put, :delete]
        end
      end
    end
  end
end