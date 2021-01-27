class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :main_category
      t.string :title
      t.string :link
      t.text :description
      t.string :code

      t.timestamps
    end
  end
end
