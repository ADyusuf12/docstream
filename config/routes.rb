Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  resource :dashboard, only: [ :show ]
  resources :inventory_items do
    member do
      get :new_restock
      patch :process_restock
    end
  end
  resources :requisitions do
    member do
      patch :approve
      patch :reject
    end
  end

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

  root "dashboards#show"
  patch :update_role, to: "users#update_role", as: :update_role
end
