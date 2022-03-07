class AddBlurToSpotlightFeaturedImages < ActiveRecord::Migration[5.2]
  def change
    add_column :spotlight_featured_images, :blur, :boolean, default: true 
  end
end
