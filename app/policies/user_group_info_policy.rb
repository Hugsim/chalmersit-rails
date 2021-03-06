class UserGroupInfoPolicy < ApplicationPolicy

  def show?
    super # TODO: https://github.com/cthit/chalmersit-rails/issues/29
  end

  def create?
    super || (user && user.in_committee?)
  end

  def update?
    super || (user && user.committees.include?(record.group))
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def delete_document?
    update?
  end


  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(group_id: user.committees.map{|c| c.slug})
      end
    end
  end
end
