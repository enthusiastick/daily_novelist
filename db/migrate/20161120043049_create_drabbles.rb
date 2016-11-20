class CreateDrabbles < ActiveRecord::Migration[5.0]
  def change
    create_table :drabbles do |t|
      t.text :body
      t.belongs_to :user
      t.integer :word_count

      t.timestamps
    end
  end
end
