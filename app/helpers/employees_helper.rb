module EmployeesHelper
  def restaurant_role_and_link(employment)
    role_name = employment.restaurant_role.try(:name) || "<em>No Role Assigned</em>"
    delete_link = link_to('Delete',
                        restaurant_employee_path(employment.restaurant, employment.employee),
                        :method => :delete,
                        :confirm => 'Are you sure?',
                        :title => 'Delete',
                        :class => "delete")
    edit_link = link_to('Edit',
                         edit_restaurant_employee_path(employment.restaurant, employment.employee),
                         :title => 'Edit',
                         :class => 'edit')
    "<p class='restaurant_role'>#{role_name}</p>#{delete_link} #{edit_link}"
  end


  def identity_details_list(employment, highlight_restaurant = false)
    list_items = [
      content_tag(:li, :class => "employee_name#{' primary' unless highlight_restaurant}") do
        if current_user || employment.employee.publish_profile?
          link_to(employment.employee.name_or_username, profile_path(employment.employee.username))
        else
          employment.employee.name_or_username
        end
      end,

      content_tag(:li, :class => 'employee_role') { employment.try(:restaurant_role).try(:name)},

      if highlight_restaurant
        content_tag(:li, :class => "restaurant_name primary") do
          employment.restaurant.name
        end
      else
        content_tag(:li, :class => "restaurant_name") do
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

  def create_staff_account_link_label(employee)
    if employee.subscription
      "Add employee Premium Account to your account"
    else
      "Upgrade employee account to Premium"
    end
  end

  def can_add_user?
    return false if @employee.complimentary_account?
    return false unless @restaurant.premium_account?
    return false if (@employee.staff_account? && @employee.subscription.payer != @restaurant)
    (@employee.account_type != "Premium") || (@employee.account_payer_type == "Personal")
  end

  def employee_link(employee)
    if on_soapbox && !employee.premium_account?
      employee.try(:name)
    else
      link_to employee.try(:name), profile_path(employee.username)
    end
  end
end
