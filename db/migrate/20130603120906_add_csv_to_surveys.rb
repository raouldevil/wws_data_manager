class AddCsvToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :csv, :text
  end
end
