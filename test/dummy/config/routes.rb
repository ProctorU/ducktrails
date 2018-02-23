Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'posts#index'

  resources :posts

  resources :pets, module: 'pets' do
    resources :kittens
  end
end
