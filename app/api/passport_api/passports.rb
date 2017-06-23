module PassportApi
  class Passports < Grape::API
    prefix :api
    version 'v1', using: :accept_version_header

    resources :passports do

      desc 'create a passport'
      params do
        requires :passport, type: Hash do
          requires :name, type: String, desc: "'Passport's name"
        end
      end
      post do
        passport = Passport.create!(name: params[:passport][:name])
        return_message(I18n.t('success'), passport)
      end

      desc 'get passport inform'
      get ':id' do
        passport = Passport.find(params[:id])
        return_message(I18n.t('success'), PassportSerializer.new(passport))
      end

      desc 'add a beer to passport'
      params do
        requires :passport_id, type: Integer, desc: 'passport id'
        requires :beer_id, type: Integer, desc: 'beer_id id'
      end
      post 'beer' do
        passport = Passport.find(params[:passport_id])
        beer = Beer.find(params[:beer_id])

        passport_beer =  PassportBeer.create!(passport_id: passport.id, beer_id: beer.id)
        return_message(I18n.t('success'), PassportBeerSerializer.new(passport_beer))
      end

      desc 'remove a beer to passport'
      params do
        requires :passport_id, type: Integer, desc: 'passport id'
        requires :beer_id, type: Integer, desc: 'beer_id id'
      end
      delete 'beer' do
        passport = Passport.find(params[:passport_id])
        beer = Beer.find(params[:beer_id])

        passport_beer =  passport.passport_beers.find_by(beer_id: beer.id)

        error!(I18n.t('not_found', title: 'Beer on Passport'), 404) if passport_beer.blank?

        passport_beer.destroy!
        return_message(I18n.t('success'), PassportBeerSerializer.new(passport_beer))
      end
    end
  end
end
