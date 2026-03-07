class ApplicationController < ActionController::API
  private

  def permitted_params
    model = controller_name.classify.constantize

    columns = model.column_names - %w[id created_at updated_at]

    attachments = model.reflect_on_all_attachments.map(&:name)

    attachments.each do |att|
      if params[att].present? && !params[att].is_a?(Array)
        params[att] = [params[att]]
      end
    end

    attachment_params = attachments.map { |att| { att => [] } }
    params.permit(*(columns + attachment_params))
  end
end