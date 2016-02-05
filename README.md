# Notifications

## Installation

Gemfile.rb

    gem 'notifications', path: '../notifications'

routes.rb

    mount Notifications::Engine => '/notifications'

application.js

    //= require 'notifications/application.js'

application.css

    *= require 'notifications/application.css'

user.rb

    def pretty_name
      email
    end

app_root/config/initializers/notifications.rb

    module Notifications
        class Engine < Rails::Engine
            config.notifications_recipient_class = Conratesecurity::User
            config.reports_recipient_class = Conratesecurity::User
            config.reports_recipient_decorator = Proc.new do |f, c|
              f.input c.name, collection: Notifications::Engine.config.reports_recipient_class.all.map { |u| [u.pretty_name, u.id] }
            end
            config.messages_recipient_decorator = Proc.new do |f, c|
              f.input c.name, collection: Notifications::Engine.config.reports_recipient_class.all.map { |u| [u.pretty_name, u.id] }
            end
            config.current_user_entity = lambda { |current_user| current_user }
        end
    end


## Usage

Render notification icons:

    <%= render 'notifications/shared/notifications', ntype: :reports, nicon: 'exclamation-triangle', nclass: 'danger' %>
    <%= render 'notifications/shared/notifications', ntype: :messages, nicon: 'envelope', nclass: 'info'%>
    <%= render 'notifications/shared/notifications', ntype: :notifications, nicon: 'bell', nclass: 'warning'%>

Send a simple message:

    Notifications::Message.create!(subject: 'Message subject', body: 'Message body', sender: Btemplater::Engine.config.current_user_entity.call(self), recipient: User.first, messagetype: :messages, owner: User.first, unread: true)

Extra: send a desktop notification:

    notifications.CheckNotification.desktopNotify('a', 'b')

## Send messages

Send a notification to one recipient:

    Notifications::Delivery::Simple.new.notification(User.first, 'Test', 'This is a <b>Test</b> message!')

Send a message to one recipient:

    Notifications::Delivery::Simple.new.message(User.first, Btemplater::Engine.config.current_user_entity.call(self), 'Test', 'This is a <b>Test</b> message!', nil)

Send a report to one recipient:

    Notifications::Delivery::Simple.new.message(User.first, Btemplater::Engine.config.current_user_entity.call(self), 'Test', 'This is a <b>Test</b> message!', nil)

## Requirements

* btemplater
* kaminari
