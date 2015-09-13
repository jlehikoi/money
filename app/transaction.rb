class Transaction
	attr_accessor :date, :sum, :party, :category

	def initialize(date, sum, party, category = nil)
		@date = date
		@sum = sum
		@party = party
		@category = category
	end

	def to_s
		"#{@date.to_s}\t\t#{@sum}\t\t#{@party}\t\t#{@category.to_s}"
	end

	# Tilitapahtumien järjestäminen siten, että uusin on ensin.
	def <=>(transaction)
		if self.date < transaction.date
			1
		elsif self.date > transaction.date
			-1
		else
			0
		end
	end

	# Tätä tarvitaan, jotta tilitapahtumia lukiessa voidaan tunnistaa mahdolliset tuplat. 
	def ==(transaction)
		self.date == transaction.date && self.sum == transaction.sum && self.party == transaction.party
	end
end