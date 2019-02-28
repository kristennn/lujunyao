Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations", :sessions => "users/sessions"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"

  resources :employees do
    collection do
      post :import_employee
    end
  end
  resources :commodities do
    collection do
      post :import_commodity
    end
  end
  resources :commodity_inventories
  resources :trading_records
  resources :wages do
    collection do
      post :import_wage
    end
  end
end
