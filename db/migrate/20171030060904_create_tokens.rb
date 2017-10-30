class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens do |t|
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
