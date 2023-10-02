Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, except: :index, shallow: true do
      post :inline_create, on: :collection
    end
  end

  root to: 'questions#index'
end
