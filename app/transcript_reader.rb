# TranscriptReader lukee, käsittelee ja tallettaa listaa tilitapahtumista (Transaction-luokka). 
class TranscriptReader

	class << self; attr_accessor :transactions end
	@transactions = []

	def initialize(files)
		files.each do |file|
			TranscriptReader.load(file)
		end
	end

	# YAML-muotoisen, tämän luokan #save-metodin tuottaman listan lataamiseksi.
	def self.load(file)
		if file.split('.').last == "yml"
			@transactions += YAML::load_file(file)
		else	
			raise "unknown file format"
		end
	end

	# Lista tilitapahtumista tallennetaan YAMLina.
	def self.save(file = "transcripts/transaction_history.yml")
		File.open(file, 'w') {|f| f.write @transactions.to_yaml}
	end

	def self.parse(files)
		files.each do |file|
			# Tilitapahtumat kopioituna on eroteltu kahdella tai useammalla välilyönnillä
			raw=CSV.read(file, col_sep: '  ')
			raw.each_with_index do |x,i| 
				# Poista useammista välilyönneistä johtuvat nil-arvot
				x.compact!
				# Poista turhat korttiosto/tilisiirto jne. tekstit
				x.delete(x[2]) if x.size == 4
				t = Transaction.new(Date.parse(x[0]), parse_number(x[1]), x[2])
				# Älä lataa tuplia (jos tiliotteet sisältävät identtisiä tapahtumia). Huom! tämä missaa samana päivänä tehdyt samansuuruiset siirrot samalle taholle,
				# ne pitää editoida käsin YAMLiin.
				@transactions << t unless @transactions.include?(t)
			end
		end

		# Jos tiedosto luettiin onnistuneesti, autokategorisoi ja järjestä lista tilitapahtumista.
		TranscriptReader.sort_transactions!
		TranscriptReader.categorize!
	end

	def self.categorize!
		Categorizer.autocategorize(@transactions.select{|t| t.category.nil?})
	end

	def self.sort_transactions!
		@transactions.sort!
	end

private
	
	# Kopioiduissa tilitapahtumissa numeroissa esiintyy turhia välilyöntejä, +-merkkejä ja pilkku desimaalierottimena.
	def self.parse_number(number)
		number.gsub(' ', '').gsub('+', '').gsub(',', '.').to_f
	end
end