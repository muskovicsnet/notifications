module Notifications
  module Delivery
    class Simple
      def initialize
      end

      def notification(recipient, subject, body)
        delivery(subject, body, nil, recipient, nil, :notifications, recipient, true)
      end

      def message(recipient, sender, subject, body, parent_id)
        delivery(subject, body, sender, recipient, nil, :notifications, sender, false)
        delivery(subject, body, sender, recipient, nil, :notifications, recipient, true)
      end

      def delivery(subject, body, sender, recipient, parent_id, messagetype, owner, unread)
        Notifications::Message.create!(
          subject: subject,
          body: body,
          sender: sender,
          recipient: recipient,
          parent_id: parent_id,
          messagetype: messagetype,
          unread: unread,
          owner: owner
        )
      end
    end
  end
end
