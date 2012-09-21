module MenuItemsHelper
	def cloud_keywords menu_items,order
		data = Hash.new

		menu_items.each do |menu_item|
				menu_item.otm_keywords.each do |otm|
					data[otm.name] = order
				end	
		end	
		return data
	end	
end
