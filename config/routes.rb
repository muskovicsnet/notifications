Notifications::Engine.routes.draw do
  scope ':messagetype' do
    resources :messages
    get 'messages/:id/reply', to: 'messages#reply', as: 'reply_message'
    post 'messages/:id/reply', to: 'messages#do_reply'
    get 'messages_count', to: 'messages#count', as: 'messages_count'
  end
end
