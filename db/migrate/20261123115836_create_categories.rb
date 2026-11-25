class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.bigint :parent_category_id, null: true

      t.timestamps
    end

    add_foreign_key :categories,
                    :categories,
                    column: :parent_category_id
  end
end
