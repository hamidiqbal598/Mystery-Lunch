Rails.application.routes.draw do

  get '/', to: 'mysteries#current_month_mystery'

  root to: 'home#index'
  # get '/:anything_else', to: 'mysteries#index'

  resources :mysteries do
    collection do
      get :current_month_mystery
    end
  end
  resources :employees

  devise_for :admins

end
