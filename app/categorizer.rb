class Categorizer

	class << self; attr_accessor :found_matches end
	@found_matches = {}

	def initialize
		Categorizer.load('categories/category_matching.yml') if File.exists?('categories/category_matching.yml')
	end

	def self.load(file)
		@found_matches = YAML::load_file(file)
	end

	def self.categorize
		uncategorized_transactions = TranscriptReader.transactions.select{|t| t.category.nil?}
		choice = ""
		
		uncategorized_transactions.each do |t|
			if @found_matches.keys.include?(t.party)
				t.category = @found_matches[t.party]
				next
			end

			puts t.to_s
			puts "Syötä kategoria: "
			category = gets("\n").strip
			break if category.downcase=="q"
			next if category.downcase=="n"
			
			t.category = category
			@found_matches[t.party] = category
			File.open('categories/category_matching.yml','w') {|f| f.write @found_matches.to_yaml}
		end
	end

	def self.autocategorize(transactions)
		transactions.each do |t|
			if @found_matches.keys.include?(t.party)
				t.category = @found_matches[t.party]
				next
			end
		end
		transactions
	end
end