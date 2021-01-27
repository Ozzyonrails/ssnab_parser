# frozen_string_literal: true

require 'roo'

namespace :models do
  desc 'Import models from spreadsheet'
  task import: :environment do
    extention = /.*\.(xlsx|csv)/
    ARGV.each do |a|
      task a.to_sym do
      end
    end

    file_path = ARGV[1]
    file_path = './' + file_path

    abort 'File not found or not supported' unless File.exist?(file_path) && file_path =~ extention

    data = Roo::Spreadsheet.open(file_path)
    print 'Importing Data'
    model_names = data.sheets

    model_names.each do |model|
      sheet = data.sheet(model)
      column_names = sheet.row(1)
      create_attributes = column_names.each_with_object({}) { |k, h| h[k] = nil }
      sheet.each_with_index do |row, index|
        next if index.zero?

        new_record_attributes = create_attributes
        column_names.each_with_index do |column, i|
          new_record_attributes[column] = row[i]
        end
        model.constantize.create(new_record_attributes)
      end
    end

    puts "\nSuccessfully."
  end
end
