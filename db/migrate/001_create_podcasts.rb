class CreatePodcasts < ActiveRecord::Migration
  def self.up
    create_table :podcasts, :force => true do |t|
      t.integer :number
      t.string :title
      t.text :description
      t.string :author
      t.string :tags
      t.date :recorded_on
      t.text :content
      t.string :permalink
      t.string :file_prefix

      t.timestamps
    end
  end

  def self.down
    drop_table :podcasts
  end
end
