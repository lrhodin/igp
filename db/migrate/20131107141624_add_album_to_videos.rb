class AddAlbumToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :album, :string
  end
end
