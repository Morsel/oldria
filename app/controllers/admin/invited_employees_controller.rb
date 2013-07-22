class Admin::InvitedEmployeesController < Admin::AdminController
 
  def index
  	@invited_employees = InvitedEmployee.all
  end
end