module FrontBurnerHelper
  
  def selected?(name)
    case name
    when "All"
      return "selected" if params[:all].present?
    when "New"
      return "selected" if params[:all].nil?
    end
    ""
  end
end
