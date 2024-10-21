class Ability
  include CanCan::Ability
  def initialize(user)
    return unless user.present?
    if user.admin?
      can :manage, Book
    else
      can :read, Book
      can :favorite, Book
    end
  end

  def unauthorized_message(action, subject)
    I18n.t('unauthorized.default')
  end
end