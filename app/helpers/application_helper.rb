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

  def user_added_book_as_favourite(user, book)
    user.favorite_books.include?(book)
  end
  
  def navbar_color(user)
    return "dark" unless user
    return "secondary" if user.admin?
    "dark"
  end

  def active_class(contoller, klass, action)
    return if EXCLUDED_ACTIONS.include?(action)
    contoller == klass ? "active" : ""
  end

  def active_action_class(action, klass)
    action == klass ? "active" : ""
  end

  EXCLUDED_ACTIONS = ["report", "favorite_books"]
end
