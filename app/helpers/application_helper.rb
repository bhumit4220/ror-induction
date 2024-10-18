# app/helpers/application_helper.rb
module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice then 'alert-info'
    when :success then 'alert-success'
    when :error then 'alert-danger'
    when :alert then 'alert-warning'
    else 'alert-info'
    end
  end
end
