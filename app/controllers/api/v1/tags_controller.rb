module Api
  module V1
    class TagsController < ApplicationController
      def index
        tags = Tag.all
        render json: { status: 'SUCCESS', message: 'Pages loaded', data: tags }, status: :ok
      end
    end
  end
end
