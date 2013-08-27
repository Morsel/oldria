module CartesHelper
	def get_all_day
		Day.all.map{|day| [day.name,day.id] }
	end
end
