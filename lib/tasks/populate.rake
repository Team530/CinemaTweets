namespace :db do
   namespace :seed do
      desc "Reads from Scrapped Data into DB."
      task :populate => :environment do
         puts 'Hello World'
      end
   end
end
