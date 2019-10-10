Rails.application.routes.draw do

	root "pages#home"

  resources :glucose_levels
  devise_for :users

end
