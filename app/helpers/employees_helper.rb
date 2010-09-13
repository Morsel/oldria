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


  def identity_details_list(employment, highlight_restaurant = false)
    list_items = [
      content_tag(:li, :class => "employee_name#{' primary' unless highlight_restaurant}") do
        employment.employee.prefers_publish_profile ? 
        link_to(employment.employee.name_or_username, profile_path(employment.employee.username)) : 
        employment.employee.name_or_username
      end,

      content_tag(:li, :class => 'employee_role') { employment.try(:restaurant_role).try(:name)},

      if highlight_restaurant
        content_tag(:li, :class => "restaurant_name primary") do
          employment.restaurant.name
        end
      else
        content_tag(:li, :class => "restaurant_name#{' primary' if highlight_restaurant}") do
          employment.employee.restaurant_names
        end
      end
    ]

    if highlight_restaurant
      restaurant_item = list_items.pop
      list_items.unshift(restaurant_item)
    end

    list_class = highlight_restaurant ? 'restaurant' : 'user'

    content_tag(:ul, list_items.join(""), :class => "identity_details #{list_class}")
  end

end
