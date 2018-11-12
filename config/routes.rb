Rails.application.routes.draw do
  
  mount Blacklight::Oembed::Engine, at: 'oembed'
  mount Riiif::Engine => '/images', as: 'riiif'
  root to: 'spotlight/exhibits#index'
  mount Spotlight::Engine, at: 'spotlight'
  mount Blacklight::Engine => '/'
#  root to: "catalog#index" # replaced by spotlight root path
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :exhibits, only: [] do
    resources :oregon_digital_resources, controller: 'oregon_digital/resources',  only: [:create, :update] do
    end
    resources :oregon_digital_list_uploads, controller: 'oregon_digital/list_upload',  only: [:create] do
    end

  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
