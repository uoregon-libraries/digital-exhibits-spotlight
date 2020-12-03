# encoding: utf-8
module OregonDigital

  # Process a list of OD pids
  class CreateResourceFromList < ActiveJob::Base
    queue_as :default

    def perform(item, exhibit)
      @params = oregon_digital_resource_params(item)
      @resource = resource(exhibit)
      add_tags
      @resource.reindex
    rescue StandardError => e
      Loggerly.debug "#{@params[:data][:solr_id]} #{e.message}"
    end

    private

    def add_tags
      return if @params[:data][:tags].blank?

      sc = sidecar
      @params[:data][:tags].each do |t|
        @resource.exhibit.tag(sc, :with => t, :on => :tags)
      end
    end

    def resource(exhibit)
      resource = Resource.new(@params)
      resource.exhibit = exhibit
      resource.save
      resource
    end

    def sidecar
      sidecar = @resource.document_model.new(id: @params[:data][:solr_id]).sidecar(@resource.exhibit)
      sidecar.resource_id = @resource.id
      sidecar.save
      sidecar
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

