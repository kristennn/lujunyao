Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations", :sessions => "users/sessions"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  resources :employees do
    collection do
      get :import_model
      post :import_employee
    end
  end
  resources :commodities
  resources :commodity_inventories
  resources :trading_records
  resources :wages
end
