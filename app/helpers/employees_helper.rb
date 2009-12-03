module EmployeesHelper
  def restaurant_role_and_link(employment)
    role_name = employment.restaurant_role.try(:name) || "<em>No Role Assigned</em>"
    delete_link = link_to('<span class="delete">Delete</span>',
                        restaurant_employee_path(employment.restaurant, employment.employee), 
                        :method => :delete, 
                        :confirm => 'Are you sure?',
                        :title => 'Delete')
    edit_link = link_to('<span class="edit">edit</span>',
                         edit_restaurant_employee_path(employment.restaurant, employment.employee),
                         :title => 'Edit')
    content_tag(:p, :class => 'restaurant_role') do
      "#{role_name} #{delete_link} #{edit_link}"
    end
  end
end
