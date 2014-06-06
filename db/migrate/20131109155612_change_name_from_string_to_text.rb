class ChangeNameFromStringToText < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.change :name, :text
    end
  end
 
  def self.down
    change_table :widgets do |t|
      t.change :name, :string
    end
  end
end
