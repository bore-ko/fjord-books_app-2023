class ChangeCloumnsNotnullAddComments < ActiveRecord::Migration[7.0]
  def change
    change_column :comments, :commentable_type, :string, null: false
    change_column :comments, :commentable_id, :integer, null: false
  end
end
