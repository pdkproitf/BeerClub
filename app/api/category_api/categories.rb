module CategoryApi
  class Categories < Grape::API
    prefix :api
    version 'v1', using: :accept_version_header

    resource :categories do

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
        @category = @current_member.bar.categories.create!(name: params[:category][:name])
        return_message(I18n.t('success'), CategorySerializer.new(@category))
      end

      desc 'get a category' #, entity: Entities::UserEntities::Users
      get ':id' do
        @category = @current_member.bar.categories.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if @category.blank?
        return_message(I18n.t('success'), CategorySerializer.new(@category))
      end

      desc 'get all category' #, entity: Entities::UserEntities::Users
      get '' do
        @category = @current_member.bar.categories.map { |e| CategorySerializer.new(e) }
        return_message(I18n.t('success'), @category)
      end

      desc 'update a category' #, entity: Entities::UserEntities::Users
      params do
        requires :category, type: Hash do
          requires :name, type: String, desc: 'Category Namer'
        end
      end
      put ':id' do
        @category = @current_member.bar.categories.find(params[:id])
        error!(I18n.t('not_found', title: 'Category'), 404) if @category.blank?
        @category.update_attributes!(name: params[:category][:name])
        return_message(I18n.t('success'), CategorySerializer.new(@category))
      end
    end
  end
end
