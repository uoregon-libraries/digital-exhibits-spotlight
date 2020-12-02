# encoding: utf-8
module OregonDigital

  # Process a list of OD pids
  class CreateResourceFromList < ActiveJob::Base
    queue_as :default

    def perform(item, exhibit)
      @params = oregon_digital_resource_params(item)
      resource = Resource.new(@params)
      resource.exhibit = exhibit
      if !resource.save_and_index
        Loggerly.debug "unable to save resource #{item}"
        return
      end
      add_tags(exhibit)
      Loggerly.debug "saved resource #{item}"
    end

    private


    def add_tags(exhibit)
      return if @params[:data][:tags].blank?
      
      @params[:data][:tags].each do |t|
        exhibit.tag(solr_doc(params).sidecar(exhibit), :with => t, :on => :tags)
      end
    end

    def solr_doc
      resource.document_model.find(id: @params[:data][:solr_id])
    rescue StandardError => e
      Loggerly.debug e.message
    end
      
    def tags(string)
      string.split(',').map{|s| s.strip }
    end

    def oregon_digital_resource_params(string)
      parts = string.split("\t")
      params = { url: "#{ ENV['OD_URL']}/catalog/#{parts.first.strip}.json" }
      params[:data] = parts.size > 1 ? { tags: tags(parts.last) } : nil
      params[:data][:solr_id] = parts.first.split(":").last.strip
      params
    end
  end
end

