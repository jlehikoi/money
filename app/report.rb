class Report

	def initialize(name, transactions)
		@name = name
		@transactions = transactions
	end

	def income
		@transactions.select{|t| t.sum>0}
	end

	def total_income 
		income.map(&:sum).sum.round(2)
	end

	def expenses
		@transactions.select{|t| t.sum<0}
	end

	def total_expenses
		expenses.map(&:sum).sum.abs.round(2)
	end

	def in_total
		@transactions.map(&:sum).sum.round(2)
	end

	def by_category
		by_category = {}
		expenses.group_by(&:category).each do |category, transactions|
			by_category[category] = transactions.map(&:sum).sum
		end
		by_category.sort_by(&:last)
	end	
end

class MonthlyReport < Report
	def inspect 
		puts @name
		puts "\tTulot: #{total_income} €"
		puts "\tMenot: #{total_expenses} €"
		puts "\tYhteensä: #{in_total} €"
		puts "\t================================\nMerkittävimmät kategoriat:"
		by_category.each do |category, value|
			puts "\t#{category}: #{value.abs.round(2)} €"
		end
	end
end

class CategoryReport < Report
	def inspect
		puts @name
		te = total_expenses
		by_category.each do |category, value|
			expense = value.abs.round(2)
			printf "%-20s %9.2f €   %s\n", "#{category}:", expense, "(#{(expense/te*100).round.to_s.rjust(2)} %)"
		end
	end
end