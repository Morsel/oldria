module CategoriesHelper
	def get_all_categories
		Category.all.map{|p| [p.name,p.id] if !p.parent_id.nil? && p.parent_id==0 }.compact
	end
end
