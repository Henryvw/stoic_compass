def random_id_generator
  random_generator = Random.new
  (random_generator.rand * 1000).to_i
end

def create_exercise
  @exercise = Exercise.new
  @exercise.title = 'How to be a Stoic?'
  @exercise.general_description = '3 Easy steps to Stoic practice.'
  @exercise.save!
end

def create_rehearsal
  @rehearsal = Rehearsal.new
  @rehearsal.id = random_id_generator
  @rehearsal.tally = 2
  @rehearsal.exercise_id = @exercise.id
  @rehearsal.user_id = @normal_user.id
  @rehearsal.city = 'Berlin'
  @rehearsal.save!
end

def create_question
  @question = Question.new
  @question.exercise_id = 1
  @question.inquiry = 'Do you practice the Discipline of Assent?'
  @question.save!
end

def create_answer
  @answer = Answer.new
  @answer.question_id = 1
  @answer.reply = 'Yes, I practice it every day.'
  @answer.rehearsal_id = 1
  @answer.save!
end

def set_exercise_owned_by_normal_user
  @exercise.user_id = @normal_user.id
end

def set_exercise_owned_by_admin_user
  @exercise.user_id = @admin_user.id
end

def visit_exercise_page
  visit exercise_path(@exercise.id)
end

def visit_edit_exercise_page
  visit edit_exercise_path(@exercise.id)
end
