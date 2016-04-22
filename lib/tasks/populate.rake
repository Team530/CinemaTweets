namespace :db do
   namespace :seed do
      desc "Reads from Scrapped Data into DB."
      task :populate => :environment do
         Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }
         movie_data = Dir["./python_parse/movie_data_out/*"]
         fin_data = Dir["./python_parse/movie_fin_data_out/*"]
         for index in 0 ... movie_data.size
            movie_data_path = movie_data[index]
            movie_file = File.open(movie_data_path, "r")

            m_n = nil
            r_d = nil
            genre = nil
            m_r = nil
            case_num = 0

            movie_file.each_line do |line|
               if line.blank?
                  unless Movie.exists?(name: m_n)
                     r_d = r_d.split(/\s*-\s*/)
                     Movie.create(name: m_n,
                                  release_date: DateTime.new(r_d[0].to_i,
                                                             r_d[1].to_i,
                                                             r_d[2].to_i),
                                 genre: genre,
                                 MPAA_rating: m_r).valid?
                  end
                  case_num = 0
               else

                  #Case 0 Movie name in; Variable: movie_name
                  case case_num
                  when 0
                     m_n = line
                  when 1
                     r_d  = line
                  when 2
                     genre = line
                  when 3
                     m_r = line
                  else
                    "You gave me #{a} in Movie Data -- I have no idea what to do with that."
                  end
                  case_num+= 1
               end
            end
         end

         for index in 0 ... fin_data.size
            fin_data_path = fin_data[index]
            fin_file = File.open(fin_data_path, "r")

            n_t = nil
            g_e = nil
            movie_name = nil
            d_g = nil
            date = nil

            fin_file.each_line do |line|
               if line.blank?

                  movie_object = Movie.find_by(name: movie_name)
                  if movie_object.nil?
                     puts "Unable to locate the following movie title: #{movie_name}"
                  else
                     m_i = movie_object.id
                     date_array = date.split(/\s*-\s*/)
                     FinancialDatum.create(num_theaters: n_t.to_i,
                                           gross_earnings: g_e.to_i,
                                           movie_id: m_i,
                                           date: DateTime.new(date_array[0].to_i,
                                                              date_array[1].to_i,
                                                              date_array[2].to_i),
                                           daily_gross: d_g.to_i).valid?
                      n_t = nil
                      g_e = nil
                      movie_name = nil
                      d_g = nil
                      date = nil
                      case_num = 0
                  end

               else

                  #Case 0 Number of theaters the movie is in; Variable: n_t
                  #Case 1 Movies total gross so far; Variable: g_e
                  #Case 2 Movie name in order to look-up id; Variable: movie_name
                  #Case 3 Previous days gross revenue; Varaible: d_g
                  #Case 4 Day that the parsed data was scanned; Varaible: date
                  case case_num
                  when 0
                     n_t = line
                  when 1
                     g_e = line
                  when 2
                     movie_name = line
                  when 3
                     d_g = line
                  when 4
                     date = line
                  else
                    "You gave me #{a} in Financial Data -- I have no idea what to do with that."
                  end
                  case_num+= 1

               end
            end
         end
      end
   end
end
