module API
  module V1
    class Categories < Grape::API
      prefix :api
      version 'v1', using: :path
      include API::V1::Default

      helpers do
        def categories
          admin_request? ? Category.all : Category.where(archived: false)
        end
      end

      resource :categories do

        desc 'get a category' , {
          entity: API::Entities::Categories.documentation,
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::CategoryBeers },
            { code: 404, message: 'Not found' }
          ]
        }
        params do
          use :authentication_param
        end
        get '/:id' do
          category = categories.find(params[:id])
          response(I18n.t('success'), CategorySerializer.new(category))
        end

        desc 'get all category', {
          detail: '',
          is_array: true,
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::CategoryBeers }
          ]
        }
        params do
          use :authentication_param
        end
        get do
          category = categories.all.map { |e| CategorySerializer.new(e) }
          response(I18n.t('success'), category)
        end

        before do
          authenticated_admin!
        end

        desc 'create new category', {
          detail: '',
          http_codes: [
            { code: 201, message: I18n.t('success'), model: API::Entities::CategoryBeers },
            { code: 400, message: "Validation failed" },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
          requires :category, type: Hash do
            requires :name, type: String, desc: 'Category Namer'
          end
        end
        post do
          category = Category.create!(name: params[:category][:name])
          response(I18n.t('success'), CategorySerializer.new(category))
        end

        desc 'update a category' , {
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::CategoryBeers },
            { code: 400, message: [ I18n.t('already_archived', content: "Category"),
                                    " Validation failed"] },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 404, message: 'Not Found' },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
          requires :category, type: Hash do
            requires :name, type: String, desc: 'Category Namer'
          end
        end
        put ':id' do
          category = Category.find(params[:id])
          category.update_attributes!(name: params[:category][:name])
          response(I18n.t('success'), CategorySerializer.new(category))
        end

        desc 'archive a category', {
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::CategoryArchived },
            { code: 400, message: I18n.t('already_archived', content: "Beer") },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 404, message: 'Not Found' },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
        end
        put ':id/archive' do
          category = Category.find(params[:id])
          error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?
          error!(I18n.t('already_archived', content: "Category")) if category.archived

          category.update_attributes!(archived: true)
          response(I18n.t('success'), CategorySerializer.new(category))
        end

        desc 'unarchive a category' , {
          detail: '',
          http_codes: [
            { code: 200, message: I18n.t('success'), model: API::Entities::CategoryBeers },
            { code: 400, message: I18n.t('not_archived', content: "Beer") },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 404, message: 'Not Found' },
            { code: 406, message: I18n.t('authen_admin') }
          ]
        }
        params do
          use :authentication_param
        end
        put ':id/unarchive' do
          category = Category.find(params[:id])
          error!(I18n.t('not_archived', content: "Category")) unless category.archived

          category.update_attributes!(archived: false)
          response(I18n.t('success'), CategorySerializer.new(category))
        end

        desc 'delete a category', {
          detail: '',
          http_codes: [
            { code: 204, message: I18n.t('success') },
            { code: 404, message: 'Not Found' },
            { code: 401, message: I18n.t('Unauthor') },
            { code: 406, message: [I18n.t('beer_using')] }
          ]
        }
        params do
          use :authentication_param
        end
        delete ':id' do
          category = Category.find(params[:id])
          error!(I18n.t('beer_using'), 406) if category.using?

          category.destroy!
          status 200
          response(I18n.t('success'))
        end
      end
    end
  end
end
