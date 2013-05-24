class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :title
      t.integer :sg_id
      t.string :status
      t.string :survey_created

      t.timestamps
    end
  end
end
