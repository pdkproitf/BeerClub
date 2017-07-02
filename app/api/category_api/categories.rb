module CategoryApi
  class Categories < Grape::API
    prefix :api
    version 'v1', using: :accept_version_header

    helpers do
      def categories
        admin_request? ? Category.all : Category.where(archived: false)
      end
    end

    resource :categories do

      desc 'get a category' #, entity: Entities::UserEntities::Users
      params do
        requires :name, type: String, desc: 'Category name'
      end
      get '/:name' do
        category = categories.find_by(name: params[:name])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?

        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'get all category' #, entity: Entities::UserEntities::Users
      get do
        category = categories.all.map { |e| CategorySerializer.new(e) }
        return_message(I18n.t('success'), category)
      end

      before do
        authenticated!
      end

      desc 'create new category' #, entity: Entities::UserEntities::Users
      params do
        requires :category, type: Hash do
          requires :name, type: String, desc: 'Category Namer'
        end
      end
      post do
        category = Category.create!(name: params[:category][:name])
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'update a category' #, entity: Entities::UserEntities::Users
      params do
        requires :category, type: Hash do
          requires :name, type: String, desc: 'Category Namer'
        end
      end
      put ':id' do
        category = Category.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?

        category.update_attributes!(name: params[:category][:name])
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'archive a category' #, entity: Entities::UserEntities::Users
      put ':id/archive' do
        category = Category.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?
        error!(I18n.t('already_archived', content: "Category")) if category.archived

        category.update_attributes!(archived: true)
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'unarchive a category' #, entity: Entities::UserEntities::Users
      put ':id/unarchive' do
        category = Category.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?
        error!(I18n.t('not_archived', content: "Category")) unless category.archived

        category.update_attributes!(archived: false)
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'delete a category'
      delete ':id' do
        category = Category.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?
        error!(I18n.t('beer_using'), 406) if category.using?

        category.destroy!
        status 200
        return_message(I18n.t('success'))
      end
    end
  end
end
