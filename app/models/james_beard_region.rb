class JamesBeardRegion < ActiveRecord::Base
  has_many :users
  has_many :restaurants

  def name_and_description(show_parentheses = true)
    @name_and_description ||= begin
      desc = (show_parentheses ? "(#{description})" : description)
      "#{name} #{desc}"
    end
  end
  # Formtastic Labels
  alias :to_label :name_and_description
end
