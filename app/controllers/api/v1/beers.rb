module API
  module V1
    class Beers < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      helpers do
        def beer_params
          ActionController::Parameters.new(params).require(:beer)
            .permit(:manufacurter, :name, :country, :price, :description, :category_id)
        end

        # using limit beer is archived response with user not Admin
        def beers
          admin_request? ? Beer.all : Beer.where(archived: false)
        end
      end

      resource :beers do

        desc 'get a beer', {
          detail: '',
          http_codes: [
            { code: 201, message: I18n.t('success'), model: API::Entities::BeersCategory },
            { code: 404, message: 'Not found' }
          ]
        }
        params do
          use :authentication_param
        end
        get '/:id' do
          beer = beers.find(params[:id])
          response(I18n.t('success'), BeerSerializer.new(beer))
        end

        desc 'get beers', {
          detail: '',
          is_array: true,
          http_codes: [{ code: 200, message: I18n.t('success'), model: API::Entities::BeersCategory }]
        }
        params do
          use :authentication_param
        end
        get do
          response(I18n.t('success'), beers.map{ |e| BeerSerializer.new(e) })
        end

        before do
          authenticated_admin!
        end

        desc 'create a beer', {
          detail: '',
          http_codes: [
            { code: 201, message: I18n.t('success'), model: API::Entities::BeersCategory },
            { code: 400, message: 'Validation failed' },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
          requires :beer, type: Hash do
            requires :manufacurter, type: String, desc: 'Manufacturer or beer'
            requires :name, type: String, desc: 'Beer name'
            requires  :category_id, type: Integer, desc: 'Category of beer'
            requires  :country, type: String, desc: 'Country of beer'
            requires  :price, type: Float, desc: 'Price of a beer'
            requires  :description, type: String, desc: 'Description of beer'
          end
        end
        post do
          category = Category.find(params[:beer][:category_id])
          error!(I18n.t('already_archived', content: 'Category'), 400) if category.archived

          beer = category.beers.create!(beer_params)
          response(I18n.t('success'), BeerSerializer.new(beer))
        end

        desc 'edit a beer', {
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::BeersCategory },
            { code: 400, message: [ I18n.t('already_archived', content: 'Category'),
                                    I18n.t('already_archived', content: 'Beer'),
                                    'Validation failed'] },
            { code: 404, message: 'Not Found' },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
          requires :beer, type: Hash do
            requires :manufacurter, type: String, desc: 'Manufacturer or beer'
            requires :name, type: String, desc: 'Beer name'
            requires  :category_id, type: Integer, desc: 'Category of beer'
            requires  :country, type: String, desc: 'Country of beer'
            requires  :price, type: Float, desc: 'Price of a beer'
            requires  :description, type: String, desc: 'Description of beer'
          end
        end
        put ':id' do
          category = Category.find(params[:beer][:category_id])
          error!(I18n.t('already_archived', content: 'Category')) if category.archived

          beer = beers.find(params[:id])
          error!(I18n.t('already_archived', content: 'Beer')) if beer.archived

          beer.update_attributes!(beer_params)
          response(I18n.t('success'), BeerSerializer.new(beer))
        end

        desc 'archived beer', {
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::BeersArchive },
            { code: 400, message: I18n.t('already_archived', content: 'Beer') },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 404, message: 'Not Found' },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
        end
        put ':id/archive' do
          beer = Beer.find(params[:id])
          error!(I18n.t('already_archived', content: 'Beer')) if beer.archived

          beer.update_attributes!(archived: true)
          response(I18n.t('success'), BeerSerializer.new(beer))
        end

        desc 'unarchived beer', {
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::BeersCategory },
            { code: 400, message: I18n.t('not_archived', content: 'Beer') },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 404, message: 'Not Found' },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
        end
        put ':id/unarchive' do
          beer = Beer.find(params[:id])
          error!(I18n.t('not_archived', content: 'Beer')) unless beer.archived

          beer.update_attributes!(archived: false)
          response(I18n.t('success'), BeerSerializer.new(beer))
        end

        desc 'delete a beer'
        delete ':id' do
          beer = @current_member.bar.beers.find(params[:id])
          error!(I18n.t('not_found', title: 'Category'), 404) if beer.blank?

          beer.destroy!

          status 200
          response(I18n.t('success'))
        end
      end
    end
  end
end
