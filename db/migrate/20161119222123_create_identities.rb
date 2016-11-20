class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.integer :provider
      t.string :uid
      t.belongs_to :user

      t.timestamps
    end
    add_index :identities, :uid, unique: true
  end
end
