class AddCreatorToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :creator, :string
  end
end
