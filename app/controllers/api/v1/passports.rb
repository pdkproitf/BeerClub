module API
  module V1
    class Passports < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      helpers do
        def get_passport
          passport_id = params[:id] || params[:passport_id]
          @passport = Passport.find(passport_id)
        end
      end

      resources :passports do
        desc 'get passports'
        params do
          use :authentication_param
        end
        get do
          authenticated_admin!
          passports = Passport.all.map { |e| PassportSerializer.new(e)  }
          response(I18n.t('success'), passports)
        end

        before do
          authenticated!
          get_passport
          error!(I18n.t('not_allow'), 406)  unless @current_user.admin? || @current_user.passport.id == @passport.id
        end

        desc 'get passport inform'
        params do
          use :authentication_param
        end
        get ':id' do
          response(I18n.t('success'), PassportSerializer.new(@passport))
        end

        desc 'add a beer to passport'
        params do
          use :authentication_param
          requires :passport_id, type: Integer, desc: 'passport id'
          requires :beer_id, type: Integer, desc: 'beer_id id'
        end
        post 'beer' do
          beer = Beer.find(params[:beer_id])
          passport_beer =  PassportBeer.create!(passport_id: @passport.id, beer_id: beer.id)
          response(I18n.t('success'), PassportBeerSerializer.new(passport_beer))
        end

        desc 'remove a beer to passport'
        params do
          use :authentication_param
          requires :passport_id, type: Integer, desc: 'passport id'
          requires :beer_id, type: Integer, desc: 'beer_id id'
        end
        delete 'beer' do
          beer = Beer.find(params[:beer_id])
          passport_beer =  @passport.passport_beers.find_by(beer_id: beer.id)
          error!(I18n.t('not_found', title: 'Beer on Passport'), 404) if passport_beer.blank?

          passport_beer.destroy!
          response(I18n.t('success'), PassportBeerSerializer.new(passport_beer))
        end
      end
    end
  end
end
