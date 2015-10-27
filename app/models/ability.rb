class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    case user.role
    when "artist"
      can :manage, :all
    when "manager"
      can :read, :all
    when "admin"
      can :manage, :all
    end
  end
end
