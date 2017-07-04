module API
  module V1
    class Passports < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      helpers do
        def current_customer
          return nil unless params[:authentication_param]
          token = params[:authentication_param][:token]
          client_id = params[:authentication_param][:client]

          customer = Customer.find_by("tokens ? '#{client_id}'")

          return customer unless customer.nil? || !customer.valid_token?(token, client_id)
          customer = nil
        end

        def valid_customer_access(passport)
          return true if current_user
          customer = current_customer
          error!(I18n.t('Unauthor'), 401) if customer.blank? || !(customer.passport.id == passport.id)
        end
      end

      resources :passports do

        desc 'get passport inform'
        params do
          use :authentication_param
        end
        get ':id' do
          passport = Passport.find(params[:id])
          valid_customer_access(passport)
          response(I18n.t('success'), PassportSerializer.new(passport))
        end

        desc 'get passports'
        params do
          use :authentication_param
        end
        get do
          authenticated!
          passports = Passport.all.map { |e| PassportSerializer.new(e)  }
          response(I18n.t('success'), passports)
        end

        desc 'add a beer to passport'
        params do
          use :authentication_param
          requires :passport_id, type: Integer, desc: 'passport id'
          requires :beer_id, type: Integer, desc: 'beer_id id'
        end
        post 'beer' do
          passport = Passport.find(params[:passport_id])
          valid_customer_access(passport)

          beer = Beer.find(params[:beer_id])
          passport_beer =  PassportBeer.create!(passport_id: passport.id, beer_id: beer.id)
          response(I18n.t('success'), PassportBeerSerializer.new(passport_beer))
        end

        desc 'remove a beer to passport'
        params do
          use :authentication_param
          requires :passport_id, type: Integer, desc: 'passport id'
          requires :beer_id, type: Integer, desc: 'beer_id id'
        end
        delete 'beer' do
          passport = Passport.find(params[:passport_id])
          valid_customer_access(passport)

          beer = Beer.find(params[:beer_id])
          passport_beer =  passport.passport_beers.find_by(beer_id: beer.id)
          error!(I18n.t('not_found', title: 'Beer on Passport'), 404) if passport_beer.blank?

          passport_beer.destroy!
          response(I18n.t('success'), PassportBeerSerializer.new(passport_beer))
        end
      end
    end
  end
end
