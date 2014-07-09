class AddFrontpageToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :frontpage, :boolean, :default => true
  end
end
