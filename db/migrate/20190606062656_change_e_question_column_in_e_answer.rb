class ChangeEQuestionColumnInAnswer < ActiveRecord::Migration[5.2]
  def change
    rename_column :answers, :e_question_id, :question_id
  end
end