Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, except: :index, shallow: true do
      patch :update_favorite, on: :member
    end
  end

  root to: 'questions#index'
end
