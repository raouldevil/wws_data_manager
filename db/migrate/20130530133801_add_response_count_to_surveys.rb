class AddResponseCountToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :response_count, :integer
  end
end
