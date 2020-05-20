source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 4.3.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7', '>= 2.7.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# ****************************************
# rails api                             *
gem 'grape' , '>= 0.19.2' #
# create grape document                 *
gem 'grape-swagger' , '>= 0.27.2' #
#  ruby code can be turned into JSON.   *
gem 'swagger-blocks'
# create swagger router                 *
gem 'grape-swagger-rails' , '>= 0.3.0' #
# => disables the security feature of   *
# => strong_params at the model         *
gem 'hashie-forbidden_attributes' #
# ****************************************

# ****************************************
gem 'grape-entity', '>= 0.6.1'
# For Grape::Entity ( https://github.com/ruby-grape/grape-entity )
gem 'grape-swagger-entity', '>= 0.2.0'
# For representable ( https://github.com/apotonick/representable )
gem 'grape-swagger-representable'           , '>= 0.1.4' #
# ****************************************
# Config helps you easily manage environment specific settings in an easy and usable manner.
gem 'config', '>= 1.4.0'
# => using for login                    *
gem 'devise_token_auth' , '>= 0.1.43' #
# => using for authenticate             *
gem 'omniauth' #
# => using for get JSON  whren your API *
# => and client on different domain     *
gem 'rack-cors', require: 'rack/cors' #

gem 'grape-active_model_serializers', '>= 1.5.1'

gem 'rails_admin', '~> 1.2', '>= 1.2.0'
# gem auto generate data
gem 'faker'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.6.0'
  # help your app run on background, make test faster
  gem 'spring-commands-rspec', '>= 1.0.4'
  # lets you express expected outcomes on collections of an object in an example.
  gem 'rspec-collection_matchers'
  gem "factory_girl_rails", "~> 4.8.0"
  # auto lanchrspec
  gem 'guard-rspec', require: false
  # using to clean data when test finish
  gem 'database_cleaner'
  gem 'simplecov', :require => false, :group => :test
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.5.1'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '>= 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :production do
  # Use postgresql as the database for Active Record
  gem 'pg', '~> 0.21.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
