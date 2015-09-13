#encoding: utf-8
require 'csv' # Verkkopankista kopioidun tilitapahtumalistan lukemiseksi. 
require 'date' # Päivämäärien käsittelemiseksi
require 'active_support' # Muutamia päivämäärien kanssa helpottavia metodeja (mm. at_beginning_of_month)
require 'active_support/core_ext'
require 'yaml' # Ohjelma tallentaa (ja lataa) tiedot YAML-muodossa.

Dir['./app/*.rb'].each {|file| require file}

TranscriptReader.new(["transcripts/transaction_history.yml"])
Categorizer.new
ReportGenerator.new.control_loop