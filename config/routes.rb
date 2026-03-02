Rails.application.routes.draw do
  devise_for :users

  resources :documents do
    member do
      post :generate_memo
      patch :submit
    end
  end

  resources :workflow_instances do
    member do
      patch :approve
      patch :reject
      get :certificate
    end
  end

  namespace :admin do
    resources :audits, only: [ :index ]
  end

  root "documents#index"
  patch :update_role, to: "users#update_role", as: :update_role
end
