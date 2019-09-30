module Api
  module V1
    class PagesController < ApplicationController
      def index
        pages = Page.includes(:tags)
        data = {}
        pages.each do |page|
          data[page.url] = page.tags.pluck(:name, :text)
        end
        render json: { status: 'SUCCESS', message: 'Pages loaded', data: data }, status: :ok
      end

      def create
        page = Page.new(page_params)
        data = {}
        message = 'Page loaded'
        response_status = 'SUCCESS'
        if page.save
          data[page.url] = page.tags.pluck(:name, :text)
        else
          message = page.errors.messages
          response_status = 'FAIL'
        end

        render json: { status: response_status, message: message, data: data }, status: :ok
      end

      private

      def page_params
        params.require(:page).permit(:url)
      end
    end
  end
end
