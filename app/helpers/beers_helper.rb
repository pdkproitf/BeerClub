module BeersHelper
  def beer_params
    ActionController::Parameters.new(params).require(:beer)
      .permit(:manufacurter, :name, :country, :price, :description)
  end
end
