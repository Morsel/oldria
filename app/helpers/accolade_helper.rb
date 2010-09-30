module AccoladeHelper

  def accolade_edit_path(accolade)
    if accolade.restaurant?
      edit_restaurant_accolade_path(accolade.accoladable, accolade)
    else
      edit_my_profile_accolade_path(accolade)
    end
  end

  def accolade_destroy_path(accolade)
    if accolade.restaurant?
      restaurant_accolade_path(accolade.accoladable, accolade)
    else
      my_profile_accolade_path(accolade)
    end
  end


end