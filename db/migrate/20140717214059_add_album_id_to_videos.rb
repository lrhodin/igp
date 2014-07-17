class AddAlbumIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :album_id, :integer
  end
end
