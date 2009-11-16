module MediaSearchesHelper

  def multiple_checkbox_search(collection, search_method)
    content_tag :ul, :class => 'multiple_checkbox' do
      collection.inject("") do |result, obj|
        checked = params[:search] && params[:search][search_method] && params[:search][search_method].include?(obj.id.to_s)
        result += "<li><label>"
        result += check_box_tag("search[#{search_method}][]", obj.id, checked)
        result += obj.name
        result += "</label></li>"
      end
    end
  end
end
