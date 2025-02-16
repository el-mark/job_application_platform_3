class CreateApplicants < ActiveRecord::Migration[8.0]
  def change
    create_table :applicants do |t|
      t.string :names
      t.string :phone
      t.text :work_experience
      t.text :education

      t.timestamps
    end
  end
end
