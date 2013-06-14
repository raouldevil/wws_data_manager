class AddDownloadedAtToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :downloaded_at, :datetime
  end
end
