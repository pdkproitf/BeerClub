Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  mount_devise_token_auth_for 'Customer', at: 'customer'
  # devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount API::V1::Base => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
