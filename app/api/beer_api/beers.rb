module BeerApi
  class Beers < Grape::API
    prefix :api
    version 'v1', using: :accept_version_header

    helpers do
      def beer_params
        ActionController::Parameters.new(params).require(:beer)
          .permit(:manufacurter, :name, :country, :price, :description)
      end

      def current_bar
        # using limit beer is archived response with user not Admin
        @limit = false
        if params[:bar_name]
          bar = Bar.find_by_name(params[:bar_name])
          error!(I18n.t('not_found', title: 'Bar'), 404) if bar.blank?

          @limit = true # account doesn't admin can't see beers are archived
          bar
        else
          authenticated!
          @current_member.bar
        end
      end
    end

    resource :beers do

      desc 'get a beer'
      params do
        optional :bar_name, type: String, desc: 'Name of Bar if you have yet login'
      end
      get '/:id' do
        bar = current_bar
        beer = @limit? bar.beers.where(archived: false).find(params[:id]) : bar.beers.find(params[:id])
        return_message(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'get beers on a bar'
      params do
        optional :bar_name, type: String, desc: 'Name of Bar if you have yet login'
      end
      get do
        bar = current_bar
        beers = @limit? bar.beers.where(archived: false) : bar.beers
        beers.map{ |e| BeerSerializer.new(e) }

        return_message(I18n.t('success'), beers)
      end

      desc 'get beers on a category'
      params do
        optional :bar_name, type: String, desc: 'Name of Bar if you have yet login'
      end
      get '/category/:id' do
        category = current_bar.categories.find(params[:id])

        beers = @limit? category.beers.where(archived: false) : category.beers
        beers.map{ |e| BeerSerializer.new(e) }

        return_message(I18n.t('success'), beers)
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
        category = @current_member.bar.categories.find(params[:beer][:category_id])
        error!(I18n.t('not_found', title: 'Category not found'), 404) if category.blank?

        beer = category.beers.create!(beer_params)
        return_message(I18n.t('success'), BeerSerializer.new(beer))
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
        category = @current_member.bar.categories.find(params[:beer][:category_id])
        error!(I18n.t('not_found', title: 'Category not found'), 404) if category.blank?

        beer = category.beers.find(params[:id])
        beer.update_attributes!(beer_params)

        return_message(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'archived beer'
      put ':id/archive' do
        beer = @current_member.bar.beers.find(params[:id])

        error!(I18n.t('already_archived', content: "Beer")) if beer.archived

        beer.update_attributes!(archived: true)
        return_message(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'unarchived beer'
      put ':id/unarchive' do
        beer = @current_member.bar.beers.find(params[:id])

        error!(I18n.t('not_archived', content: "Beer")) unless beer.archived

        beer.update_attributes!(archived: false)
        return_message(I18n.t('success'), BeerSerializer.new(beer))
      end

      # desc 'delete a beer'
      # delete ':id' do
      #   beer = @current_member.bar.beers.find(params[:id])
      #   error!(I18n.t('not_found', title: 'Category'), 404) if beer.blank?
      #
      #   beer.destroy!
      #
      #   status 200
      #   return_message(I18n.t('success'))
      # end
    end
  end
end
