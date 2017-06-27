Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  mount_devise_token_auth_for 'Customer', at: 'auth'

  as :customer do
    # Define routes for Customer within this block.
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount API::Root => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
