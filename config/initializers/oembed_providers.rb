require 'oembed'

OEmbed::Providers.register_all

embed_provider = OEmbed::Provider.new(ENV['OD_URL'] + "/oembed/?format=json")
embed_provider << ENV['OD_URL'] + "/resource/*"
OEmbed::Providers.register(embed_provider)