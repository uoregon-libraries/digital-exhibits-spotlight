module Spotlight
  module Resources
    class IiifListUploadController < ApplicationController
      helper :all

      before_action :authenticate_user!

      load_and_authorize_resource :exhibit, class: Spotlight::Exhibit

      def create
        IO.readlines(list_params[:file].to_io).each do |line|
          CreateIiifResourceFromList.perform_later(line, current_exhibit)
        end
        flash[:notice] = "File uploaded, items are being processed."
        redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit, sort: :timestamp)
      end

      private

      def list_params
        params.require(:resources_iiif_list_upload).permit(:file)    
      end
    end
  end
end
