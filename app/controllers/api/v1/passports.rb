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
        desc 'get passports', {
          is_array: true,
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::Passports },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
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

        desc 'get passport inform', {
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::PassportsBeer },
            { code: 404, message: 'Not Found' },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: I18n.t('not_allow') }
          ]
        }
        params do
          use :authentication_param
        end
        get ':id' do
          response(I18n.t('success'), PassportSerializer.new(@passport))
        end

        desc 'add a beer to passport', {
          detail: '',
          http_codes: [
            { code: 201, message: I18n.t('success'), model: API::Entities::PassportsBeer },
            { code: 404, message: 'Not Found' },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: I18n.t('not_allow') }
          ]
        }
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

        desc 'remove a beer to passport', {
          detail: '',
          http_codes: [
            { code: 204, message: I18n.t('success') },
            { code: 404, message: 'Not Found' },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: I18n.t('not_allow') }
          ]
        }
        params do
          use :authentication_param
          requires :passport_id, type: Integer, desc: 'passport id'
          requires :beer_id, type: Integer, desc: 'beer_id id'
        end
        delete 'beer' do
          status 204
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
