module Notifications
  class MessagePolicy < Notifications::ApplicationPolicy
    def permitted_attributes
      [:subject, :body, :recipient_id]
    end

    def index?
      !@user.nil?
    end

    def show?
      !@user.nil? && @record.owner == @user
    end

    def new?
      create?
    end

    def create?
      !@user.nil? && %w(reports messages).include?(@record.try(:messagetype))
    end

    def reply?
      create?
    end

    def do_reply?
      reply?
    end

    def messages_count?
      index?
    end

    def destroy?
      @record.owner == @user
    end
  end
end
