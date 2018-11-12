
module OregonDigital

  class ListUploadController < ApplicationController
    helper :all

    before_action :authenticate_user!

    load_and_authorize_resource :exhibit, class: Spotlight::Exhibit

    def create
      list = IO.readlines(list_params[:file].to_io)
      CreateResourcesFromList.perform_later(list, current_exhibit)
      flash[:notice] = "File uploaded, items are being processed."
      redirect_back(fallback_location: spotlight.exhibit_resources_path(current_exhibit))
    end

    private

    def list_params
      params.require(:oregon_digital_list_upload).permit(:file)
    end
  end
end


