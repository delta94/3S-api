class AddAcceptedToPlace < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :accepted, :boolean
  end
end
