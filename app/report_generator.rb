class ReportGenerator
	
	def control_loop
		choice = ""
		while !(choice.downcase == "q")
			puts "1. Kuukausittainen saldo"
			puts "2. Kuluvan vuoden merkitävimmät kulutyypit"
			puts "-----------------"
			puts "C. Kategorisoi"
			puts "S. Tallenna"
			puts "Q. Lopeta"
			puts "\nValinta: "
			choice = gets("\n").strip

			if choice=="1"
				system "clear"
				monthly_report
			elsif choice=="2"
				system "clear"
				category_report
			elsif choice.downcase=="c"
				Categorizer.categorize
			elsif choice.downcase=="s"
				TranscriptReader.save
			end
		end
	end

private
	def monthly_report
		start_date = month_year_selection("Valitse aloituskuukausi", false)
		end_date = month_year_selection("Valitse viimeinen kuukausi", true)
		
		puts "\n"
		monthly_sums = []
		(start_date..end_date).select{|d| d.day == 1}.each do |first_day|
			last_day = first_day.at_end_of_month
			transactions = TranscriptReader.transactions.select{|t| t.date>=first_day && t.date<=last_day}
			MonthlyReport.new("#{first_day.month.to_s.rjust(2, '0')}-#{first_day.year}", transactions).inspect
			gets
			system "clear"	
		end
	end

	def category_report
		start_date = Date.today.at_beginning_of_year
		CategoryReport.new("Merkittävimmät kuluerät kuluneen vuoden aikana:", TranscriptReader.transactions.select{|t| t.sum<0 && t.date>=start_date}).inspect
		gets
		system "clear"
	end

	def month_year_selection(text, at_end = false)
		puts text
		puts "Syötä kuukausi ja vuosi esim. muodossa 01-2015."
		month_year = gets("\n").strip
		month = month_year.split(/\D/).first
		year = month_year.split(/\D/).last
		if at_end
			Date.parse("#{year}-#{month}-01").at_end_of_month
		else
			Date.parse("#{year}-#{month}-01").at_beginning_of_month
		end
	end
end