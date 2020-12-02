
module OregonDigital

  class ListUploadController < ApplicationController
    helper :all

    before_action :authenticate_user!

    load_and_authorize_resource :exhibit, class: Spotlight::Exhibit

    def create
      IO.readlines(list_params[:file].to_io).each do |line|
        CreateResourceFromList.perform_later(line, current_exhibit)
      end
      flash[:notice] = "File uploaded, items are being processed."
      redirect_back(fallback_location: spotlight.exhibit_resources_path(current_exhibit))
    end

    private

    def list_params
      params.require(:oregon_digital_list_upload).permit(:file)
    end
  end
end


