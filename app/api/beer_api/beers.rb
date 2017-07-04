module BeerApi
  class Beers < Grape::API
    prefix :api
    version 'v1', using: :path

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

      desc 'get a beer'
      get '/:id' do
        beer = beers.find(params[:id])
        response(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'get beers'
      get do
        response(I18n.t('success'), beers.map{ |e| BeerSerializer.new(e) })
      end

      before do
        authenticated!
      end

      desc 'create a beer'
      params do
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
        error!(I18n.t('already_archived', content: "Category"), 400) if category.archived

        beer = category.beers.create!(beer_params)
        response(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'edit a beer'
      params do
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
        error!(I18n.t('already_archived', content: "Category")) if category.archived

        beer = beers.find(params[:id])
        error!(I18n.t('already_archived', content: "Beer")) if beer.archived

        beer.update_attributes!(beer_params)
        response(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'archived beer'
      put ':id/archive' do
        beer = Beer.find(params[:id])
        error!(I18n.t('already_archived', content: "Beer")) if beer.archived

        beer.update_attributes!(archived: true)
        response(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'unarchived beer'
      put ':id/unarchive' do
        beer = Beer.find(params[:id])
        error!(I18n.t('not_archived', content: "Beer")) unless beer.archived

        beer.update_attributes!(archived: false)
        response(I18n.t('success'), BeerSerializer.new(beer))
      end

      # desc 'delete a beer'
      # delete ':id' do
      #   beer = @current_member.bar.beers.find(params[:id])
      #   error!(I18n.t('not_found', title: 'Category'), 404) if beer.blank?
      #
      #   beer.destroy!
      #
      #   status 200
      #   response(I18n.t('success'))
      # end
    end
  end
end
