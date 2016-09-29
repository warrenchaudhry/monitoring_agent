Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/metrics', to: 'metrics#index'
  root to: 'metrics#index'
  mount ActionCable.server => '/cable'
end
