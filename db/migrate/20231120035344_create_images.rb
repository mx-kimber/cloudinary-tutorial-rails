class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.string :cloudinary_photo

      t.timestamps
    end
  end
end
