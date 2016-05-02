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
            genres = nil
            m_r = nil
            budget = nil
            r_t = nil
            case_num = 0

            movie_file.each_line do |line|
               if line.blank?

                  budget = budget == "N/A" ?  0 : budget
                  genres = genres.split(/\s*,\s*/)

                  genres.each do |genre|
                     unless Genre.exists?(genre_name: genre)
                        Genre.create(count: 0,
                                     genre_name: genre).valid?
                     end
                  end

                  if Movie.exists?(name: m_n)
                     movie_id = Movie.find_by(name: m_n).id
                     unless GenreTag.exists?(movie_id: movie_id)
                        genres.each do |genre|
                           genre_model = Genre.find_by(genre_name: genre)
                           genre_id = genre_model.id
                           count = genre_model.count
                           GenreTag.create(movie_id: movie_id,
                                           genre_id: genre_id).valid?

                           count =  count + 1
                           Genre.update(genre_id, count: count)
                        end
                     end

                  else
                     r_d = r_d.split(/\s*-\s*/)
                     Movie.create(name: m_n,
                                  release_date: DateTime.new(r_d[0].to_i,
                                                             r_d[1].to_i,
                                                             r_d[2].to_i),
                                 MPAA_rating: m_r,
                                 budget: budget).valid?
                     movie_id = Movie.find_by(name: m_n).id
                     genres.each do |genre|
                        genre_model = Genre.find_by(genre_name: genre)
                        genre_id = genre_model.id
                        count = genre_model.count
                        GenreTag.create(movie_id: movie_id,
                                        genre_id: genre_id).valid?

                        count =  count + 1
                        Genre.update(genre_id, count: count)

                     end
                  end
                  m_n = nil
                  r_d = nil
                  genres = nil
                  m_r = nil
                  budget = nil
                  r_t = nil
                  case_num = 0
               else

                  case case_num
                  when 0
                     m_n = line.chomp
                  when 1
                     r_d  = line.chomp
                  when 2
                     genres = line.chomp
                  when 3
                     m_r = line.chomp
                  when 4
                     budget = line.chomp
                  when 5
                     r_t = line.chomp
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
                     date_array = date.split(/\s*-\s*/)
                     date_value = DateTime.new(date_array[0].to_i,
                                        date_array[1].to_i,
                                        date_array[2].to_i)
                     m_i = movie_object.id
                     unless FinancialDatum.exists?(movie_id: m_i, date: date_value)

                        FinancialDatum.create(num_theaters: n_t.to_i,
                                              gross_earnings: g_e.to_i,
                                              movie_id: m_i,
                                              date: date_value,
                                              daily_gross: d_g.to_i).valid?
                                              
                     end
                  end
                  case_num = 0
                  n_t = nil
                  g_e = nil
                  movie_name = nil
                  d_g = nil
                  date = nil
               else

                  #Case 0 Number of theaters the movie is in; Variable: n_t
                  #Case 1 Movies total gross so far; Variable: g_e
                  #Case 2 Movie name in order to look-up id; Variable: movie_name
                  #Case 3 Previous days gross revenue; Varaible: d_g
                  #Case 4 Day that the parsed data was scanned; Varaible: date
                  case case_num
                  when 0
                     n_t = line.chomp
                  when 1
                     g_e = line.chomp
                  when 2
                     movie_name = line.chomp
                  when 3
                     d_g = line.chomp
                  when 4
                     date = line.chomp
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
