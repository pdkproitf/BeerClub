module BeerApi
  class Beers < Grape::API
    prefix :api
    version 'v1', using: :accept_version_header

    helpers BeersHelper

    resource :beers do

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

      desc 'get a beer'
      get '/:id' do
        beer = @current_member.bar.beers.find(params[:id])

        return_message(I18n.t('success'), BeerSerializer.new(beer))
      end

      desc 'get beers on a bar'
      get do
        beers = @current_member.bar.beers.map{ |e| BeerSerializer.new(e) }
        return_message(I18n.t('success'), beers)
      end

      desc 'get beers on a category'
      get '/category/:id' do
        category = @current_member.bar.categories.find(params[:id])
        beers = category.beers.map{ |e| BeerSerializer.new(e) }
        return_message(I18n.t('success'), beers)
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
    end
  end
end
