# encoding: utf-8
module OregonDigital

  # Process a list of OD pids
  class CreateResourcesFromList < ActiveJob::Base
    queue_as :default

    def perform(list, exhibit)
      list.each do |pid|
        resource = Resource.new( oregon_digital_resource_param(pid))
        resource.exhibit = exhibit

        if resource.save_and_index
          logger.info "saved resource #{pid}"
        else
          logger.warn "unable to save resource #{pid}"
        end
      end
    end

    private

    def oregon_digital_resource_param(pid)
      { url: "#{ ENV['OD_URL']}/catalog/#{pid.strip}.json" }
    end
  end
end

