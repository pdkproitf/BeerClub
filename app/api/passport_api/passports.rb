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
    end
  end
end
