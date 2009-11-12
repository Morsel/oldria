module EmployeesHelper
  def restaurant_role_and_link(employment)
    role_name = employment.restaurant_role.try(:name) || "<em>No Role Assigned</em>"
    edit_link = link_to('<span class="utility">edit</span>',
                         edit_restaurant_employee_path(employment.restaurant, employment.employee))
    content_tag(:p, :class => 'restaurant_role') do
      "#{role_name} #{edit_link}"
    end
  end
end
