module Notifications
  class MessagesController < Notifications::ApplicationController
    helper Btemplater::ApplicationHelper
    helper Btemplater::IndexHelper
    helper Btemplater::ShowHelper
    helper Btemplater::NewHelper
    include Btemplater::Tools

    def index
      messagetype = params[:messagetype]
      @objects = Notifications::Message.where(messagetype: messagetype).where(owner: Btemplater::Engine.config.current_user_entity.call(self)).order('created_at desc').page(params[:page])
    end

    def show
      @obj = Notifications::Message.find(params[:id])
      @obj.unread = false
      @obj.save!
    end

    def new
      @obj = Notifications::Message.new
      @obj.messagetype = params[:messagetype]
    end

    def create
      Notifications::Message.transaction do
        do_create(params, Notifications::Message, notifications.messages_path(params[:messagetype]))
        create_duplicate(@obj)
      end
    rescue ActiveRecord::RecordInvalid
      render :new
    end

    def reply
      @prev_obj = Notifications::Message.find(params[:id])
      @obj = Notifications::Message.new
      @obj.messagetype = @prev_obj.messagetype
      @obj.parent_id = @prev_obj.id
      @obj.recipient = @prev_obj.sender
      @obj.subject = "#{t('notifications.re', scope: :notifications)}#{@prev_obj.subject}"
      @obj.body = "\n\n#{@prev_obj.body.split("\n").map{|x| "> #{x}"}.join("\n")}"
    end

    def do_reply
      Notifications::Message.transaction do
        # TODO: hogynézki?
        @prev_obj = Notifications::Message.find(params[:id])
        @obj = Notifications::Message.new
        @obj.parent_id = @prev_obj.id
        @obj.recipient = @prev_obj.sender
        @obj.sender = Btemplater::Engine.config.current_user_entity.call(self)
        @obj.subject = params[:message][:subject]
        @obj.body = params[:message][:body]
        @obj.owner = Btemplater::Engine.config.current_user_entity.call(self)
        @obj.messagetype = @prev_obj.messagetype
        @obj.unread = false
        @obj.save!
        create_duplicate(@obj)
      end
      redirect_to notifications.messages_path(params[:messagetype])
    end

    def destroy
      do_destroy(params, Notifications::Message, notifications.messages_path)
    end

    def count
      if user_signed_in?
        render json: Notifications::Message.where(messagetype: params[:messagetype]).where(unread: true).where(owner: Btemplater::Engine.config.current_user_entity.call(self)).count
      else
        render json: 0
      end
    end

    def before_save_create(obj)
      obj.recipient_type = Notifications::Engine.config.send("#{params[:messagetype]}_recipient_class")
      obj.messagetype = params[:messagetype]
      obj.unread = false
      obj.owner = Btemplater::Engine.config.current_user_entity.call(self)
      obj.sender = Btemplater::Engine.config.current_user_entity.call(self)
    end

    private

    def create_duplicate(obj)
      other = obj.dup
      # tmp = other.sender
      other.owner = other.recipient
      other.unread = true
      other.save
    end
  end
end
