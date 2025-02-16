class AddResultsToApplicants < ActiveRecord::Migration[8.0]
  def change
    add_column :applicants, :results, :integer
  end
end
