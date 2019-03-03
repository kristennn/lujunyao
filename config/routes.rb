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
  resources :commodity_inventories do
    collection do
      get :show_modal
      get :edit_modal
    end
    member do
      get :update_event
    end
  end
  resources :trading_records do
    collection do
      get :show_edit_modal
      get :choose_commodity
    end
  end
  resources :wages do
    collection do
      post :import_wage
      get :show_edit_modal
      get :show_pay_modal
      post :pay_cash
    end
  end
end
