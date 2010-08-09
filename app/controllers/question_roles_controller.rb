class QuestionRolesController < ApplicationController
  
  def create
    role = QuestionRole.new(params[:question_role])
    if role.save
      flash[:notice] = "Created role #{role.name}"
    end
    redirect_to roles_admin_profile_questions_path
  end

end
