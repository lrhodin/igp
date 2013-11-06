class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.text :description
      t.string :thumb
      t.date :date
      t.string :vid

      t.timestamps
    end
  end
end
