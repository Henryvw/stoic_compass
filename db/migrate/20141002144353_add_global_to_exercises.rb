class AddGlobalToExercises < ActiveRecord::Migration[5.2]
  def change
    add_column :exercises, :global, :boolean
  end
end
