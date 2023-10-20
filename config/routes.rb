Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    patch :update_best_answer, on: :member

    resources :answers, except: :index, shallow: true
  end

  root to: 'questions#index'
end
