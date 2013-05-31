module TestDataHelpers
	def zip_code_for(prefix, num)
		num = 1 if num < 1
		num = num%100
	
		last_austin_suffix = 89
		num = 1 if num == last_austin_suffix
	
		missing_austin_suffixes = [06, 07, 40, 43, 70, 75, 76, 77, 84]
		num = 1 if missing_austin_suffixes.include? num
	
	 	suffix = "%02d" % (num % 100)

		"#{prefix}#{suffix}"
	end

	def phone_number_for(area_code, prefix, num)
		suffix = "%04d" % (num % 10000)
		"(#{area_code}) #{prefix}-#{suffix}"
	end

	def lat_for(zip_code)
		ZipCode.find_by_zip_code(zip_code).lat
	end

	def lng_for(zip_code)
		ZipCode.find_by_zip_code(zip_code).lng
	end

	def random_category
		category_count = 44
		Category.find(1 + rand(category_count))
	end
end