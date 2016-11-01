class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.string :sUserID, null: false, limit: 20
      t.string :name, limit: 20
      t.date :birthday
      t.string :sex, limit: 2
      t.string :married, limit: 2
      t.string :children, limit: 2
      t.string :job, limit: 100
      t.string :hobby, limit: 100
      t.integer :currentShot

      t.timestamps
    end
    
    execute "ALTER TABLE users ADD PRIMARY KEY (sUserID);"
  end
end
