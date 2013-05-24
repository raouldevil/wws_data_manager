class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :survey_id
      t.integer :sg_response_id
      t.text :json_response

      t.timestamps
    end
  end
end
