module Api
  class ProductsController < BaseController

    expose(:Products) {
      Product.all
    }

    respond_to :json

    api :GET,
        "/Products",
        "returns all Products"
    def index
      respond_with(
        Products,
        each_serializer: Api::ProductSerializer
      )
    end
  end
end
