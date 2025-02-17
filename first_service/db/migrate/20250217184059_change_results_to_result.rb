class ChangeResultsToResult < ActiveRecord::Migration[8.0]
  def change
    rename_column :applicants, :results, :ai_result
  end
end
