class AddAiResultDescriptionToApplicants < ActiveRecord::Migration[8.0]
  def change
    add_column :applicants, :ai_result_description, :text
  end
end
