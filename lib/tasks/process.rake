namespace :process do

  task :reprocess, [:start] => :environment do |task, args|
    current = args.start.to_i || 0
    total_size = Workbook.all.size
    puts "TOTAL NUM WORKBOOKS: #{total_size}"
    Workbook.all.offset(current).each do |workbook|
      active_file = workbook.active_workbook_file
      if (active_file)
        puts "Reimporting #{current}/#{total_size}"
        active_file.reimport!
      end
      current += 1
    end
  end

end