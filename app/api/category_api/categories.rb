module CategoryApi
  class Categories < Grape::API
    prefix :api
    version 'v1', using: :accept_version_header

    helpers do
      def current_bar
        if params[:bar_name]
          bar = Bar.find_by_name(params[:bar_name])
          error!(I18n.t('not_found', title: 'Bar'), 404) if bar.blank?
          bar
        else
          authenticated!
          @current_member.bar
        end
      end
    end

    resource :categories do

      desc 'get a category' #, entity: Entities::UserEntities::Users
      params do
        optional :bar_name, type: String, desc: 'Name of Bar if you have yet login'
      end
      get ':id' do
        category = current_bar.categories.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?

        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'get all category' #, entity: Entities::UserEntities::Users
      params do
        optional :bar_name, type: String, desc: 'Name of Bar if you have yet login'
      end
      get do
        category = current_bar.categories.map { |e| CategorySerializer.new(e) }
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
      post '/' do
        category = @current_member.bar.categories.create!(name: params[:category][:name])
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'update a category' #, entity: Entities::UserEntities::Users
      params do
        requires :category, type: Hash do
          requires :name, type: String, desc: 'Category Namer'
        end
      end
      put ':id' do
        category = @current_member.bar.categories.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?

        category.update_attributes!(name: params[:category][:name])
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'archive a category' #, entity: Entities::UserEntities::Users
      put ':id/archive' do
        category = @current_member.bar.categories.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?

        error!(I18n.t('already_archived', content: "Category")) if category.archived

        category.update_attributes!(archived: true)
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'archive a category' #, entity: Entities::UserEntities::Users
      put ':id/unarchive' do
        category = @current_member.bar.categories.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?

        error!(I18n.t('not_archived', content: "Category")) unless category.archived

        category.update_attributes!(archived: false)
        return_message(I18n.t('success'), CategorySerializer.new(category))
      end

      desc 'delete a category'
      delete ':id' do
        category = @current_member.bar.categories.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if category.blank?

        error!(I18n.t('beer_using'), 406) if category.using?

        category.destroy!

        status 200
        return_message(I18n.t('success'))
      end
    end
  end
end
