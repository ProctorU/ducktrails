Rails.application.routes.draw do
  root to: 'pets#index'

  resources :pets do
    resources :kittens
  end
end
