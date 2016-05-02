#!bin/python3

import datetime, time, sys, traceback, logging
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

MONTHS = {'January' : 1, 'February' : 2, 'March' : 3, 'April' : 4, 'May' : 5,
          'June' : 5, 'July' : 6, 'August' : 8, 'September' : 9,
          "October" : 10, 'November' : 11, 'December' : 12}

class ScrapeInfo(object):

    #Data Structure info
    #Key is the name of the movie
    #Stores a tuple where
    #Pos 0 = Current Position
    #Pos 1 = Last Position
    #Pos 2 = Distributor
    #Pos 3 = Previous Day's Gross
    #Pos 4 = Change
    #Pos 5 = Num Theaters
    #Pos 6 = Gross per Theaters
    #Pos 7 = Total Gross
    #Pos 8 = Number of Days Released
    movie_data = {}
    cleaned_movie_data = {}
    cur_search_date = datetime.datetime.now() - datetime.timedelta(1)
    GOOGLE_SEARCH_STRING = "https://www.google.com/search?q="
    def __init__(self):

        profile = webdriver.FirefoxProfile("/home/christopher/.mozilla/firefox/m3hrfqdg.default")
        self.driver = webdriver.Firefox(profile)
        self.driver.implicitly_wait(3)
        #http://www.the-numbers.com/box-office-chart/daily/2016/04/19
        # - datetime.timedelta(29)
        self.cur_search_date = self.cur_search_date
        start = self.goToDate()
        self.driver.get(start)
        self.driver.implicitly_wait(10)

    def goBackADay(self):
        self.cur_search_date = self.cur_search_date  - datetime.timedelta(1)

    def goToDate(self):
        return str("http://www.the-numbers.com/box-office-chart/daily/" +
                    str(self.cur_search_date.year) + "/" +
                    str(self.formatDate(self.cur_search_date.month)) + "/" +
                    str(self.formatDate(self.cur_search_date.day)))

    def formatDate(self, date):
        return '{:02d}'.format(date)


    def printOutToFile(self):
        movie_info_file_name = ("./movie_data_out/movie_info_file_" +
                                 self.cur_search_date.strftime("%d-%m-%Y"))
        financial_info_file_name = ("./movie_fin_data_out/financial_info_file_"
                                    + self.cur_search_date.strftime("%d-%m-%Y"))
        f_m = open(movie_info_file_name, 'w')
        f_f = open(financial_info_file_name, 'w')

        for movie_name in self.cleaned_movie_data:
            movie_info = self.cleaned_movie_data[movie_name]
            f_m.write(movie_name + "\n")
            f_m.write(str(movie_info['release_date'][2]) + "-" +
                      str(movie_info['release_date'][1]) + "-" +
                      str(movie_info['release_date'][0]) + "\n")
            f_m.write(', '.join(str(x) for x in movie_info['genre'])  + "\n")
            f_m.write(str(movie_info['MPAA_rating'])  + "\n")
            f_m.write(str(movie_info['budget'])  + "\n")
            f_m.write(str(movie_info['run_time'])  + "\n")
            f_m.write("\n")

            f_f.write(str(movie_info['num_theaters']) + "\n")
            f_f.write(str(movie_info['total_gross']) + "\n")
            f_f.write(movie_name + "\n")
            f_f.write(str(movie_info['prev_day_gross']) + "\n")
            f_f.write( (str(self.cur_search_date.year) + "-" +
                        str(self.formatDate(self.cur_search_date.month)) + "-" +
                        str(self.formatDate(self.cur_search_date.day)))+ "\n")
            f_f.write("\n")

        f_m.close()
        f_f.close()

    def main(self):
        count = 0
        while count < 14:
            print("Parsing Data for: " + self.cur_search_date.strftime("%d/%m/%Y"))
            soup_data = self.getSoupData()
            self.parseData(soup_data)
            self.getMovieInfo()
            self.printOutToFile()
            self.goBackADay()
            start = self.goToDate()
            self.driver.get(start)
            count = count + 1
            self.movie_data.clear()
            self.cleaned_movie_data.clear()
        self.driver.close()

    def getSoupData(self):
        content = self.driver.page_source
        soup = BeautifulSoup(content, "html.parser")
        return soup

    def removeWhitSpace(self, text):
        return text.replace(u'\xa0', u' ').strip()

    def stripForNumOnly(self, text):
        stripped_text = self.removeWhitSpace(text)
        ret = ''.join(filter(lambda x: x.isdigit() , stripped_text))
        if not ret:
            return "-"
        return ret

    def stripForPercent(self, text):
        stripped_text = self.removeWhitSpace(text)
        ret = ''.join(filter(lambda x: x.isdigit() or x is "+" or x is "-", stripped_text))
        if not ret:
            return "-"
        return ret

    def convertToMins(self, time):
        time_array = time.split()

        seen_min = False
        seen_hour = False

        min_time = 0
        hour_time = 0
        for ele in time_array:
            if "h" in ele:
                seen_hour = True
                hour_time = self.stripForNumOnly(ele)
            elif "min" in ele:
                seen_min = True
                min_time = self.stripForNumOnly(ele)

        if seen_min == True and seen_hour == False:
            return min_time
        if seen_min == True and seen_hour == True:
            return int(min_time) + int(60*int(hour_time))
        if seen_min == False and seen_hour == True:
            return int(60*int(hour_time))

    def stripDate(self, text):
        date = text.split()
        ret = []
        for ele in date:
            if ele.isdigit():
                ret.append(ele)
            elif ele in MONTHS:
                ret.append(MONTHS[ele])
        return ret

    def parseData(self, soup_data):
        for r in soup_data.find_all('tr')[2:-1]:
            data = r.find_all('td')
            #Data comes as an array
            #Pos 0 = Current Position
            #Pos 1 = Last Position
            #Pos 2 = Movie Name
            #Pos 3 = Distributor
            #Pos 4 = Previous Day's Gross
            #Pos 5 = Change
            #Pos 6 = Num Theaters
            #Pos 7 = Gross per Theaters
            #Pos 8 = Total Gross
            #Pos 9 = Number of Days Released
            current_pos    = self.stripForNumOnly(data[0].text)
            last_pos       = self.stripForNumOnly(data[1].text)
            movie_name     = self.removeWhitSpace(data[2].text)
            distributor    = self.removeWhitSpace(data[3].text)
            prev_day_gross = self.stripForNumOnly(data[4].text)
            change         = self.stripForPercent(data[5].text)
            num_theaters   = self.stripForNumOnly(data[6].text)
            per_theater    = self.stripForNumOnly(data[7].text)
            total_gross    = self.stripForNumOnly(data[8].text)
            num_days       = self.stripForNumOnly(data[9].text)
            movie_info = { "current_pos" : current_pos, "last_pos" :last_pos,
                           "distributor" : distributor,
                           "prev_day_gross" : prev_day_gross,
                           "change" : change, "num_theaters" : num_theaters,
                           "per_theater" : per_theater,
                           "total_gross" : total_gross, "num_days" : num_days}
            self.movie_data[movie_name] = movie_info

    def getMovieInfo(self):
        counter = 1
        error_counter = 1;
        for movie_title in self.movie_data:
            try:
                print("Item number: " + str(counter) + " for " + movie_title)
                time.sleep(3)
                search_query = (self.GOOGLE_SEARCH_STRING +
                                str(movie_title) + " IMDb " +
                                str(self.cur_search_date.year) +" movie")

                self.driver.get(search_query)
                self.driver.implicitly_wait(10)
                soup_data = self.getSoupData()
                div_data = soup_data.findAll('div', class_="rc")
                if not div_data:
                    print("No data found for " + str(movie_title))
                    continue
                else:
                    first_div = div_data[0]
                    links = first_div.findAll('a', href=True)
                    if not links:
                        print("Not able to grab data for " + str(movie_title))
                    else:
                        link = links[0]
                        link_string = link['href']
                        self.driver.get(link_string)
                        self.driver.implicitly_wait(10)
                        soup_data = self.getSoupData()
                        IMDb_movie_title = soup_data.find(itemprop="name").get_text()
                        movie_classificaiton = "N/A"
                        try:
                            movie_classificaiton = soup_data.find(itemprop="contentRating")['content']
                        except:
                            pass
                        movie_duration = self.convertToMins(soup_data.find(itemprop="duration").get_text())
                        movie_genres = soup_data.findAll('span',itemprop="genre")
                        budget_and_release_div = soup_data.findAll('div', class_="txt-block")
                        budget = "N/A"
                        release_date = "N/A"
                        movie_genres_parsed = []
                        if not IMDb_movie_title:
                            print("Unable to get movie title")
                            continue
                        if movie_genres:
                            for ele in movie_genres:
                                movie_genres_parsed.append(self.removeWhitSpace(ele.text))
                        if budget_and_release_div:
                            for ele in budget_and_release_div:
                                for header_tag in ele.findAll('h4'):
                                    if self.removeWhitSpace(header_tag.text) == "Budget:":
                                        budget = self.stripForNumOnly(str(header_tag.next_sibling))
                                    if self.removeWhitSpace(header_tag.text) == "Release Date:":
                                        release_date = self.stripDate(str(header_tag.next_sibling))

                        print("Extracting information for: "+ IMDb_movie_title)
                        movie_info = self.movie_data[movie_title]
                        movie_info["genre"] = movie_genres_parsed
                        movie_info["run_time"] = movie_duration
                        movie_info["budget"] = budget
                        movie_info["release_date"] = release_date
                        movie_info["MPAA_rating"] = movie_classificaiton

                        self.cleaned_movie_data[IMDb_movie_title] = movie_info
                        print(self.cleaned_movie_data[IMDb_movie_title])
                        print()
                        counter = counter + 1
                        time.sleep(2)
            except ConnectionRefusedError:
                quit(0)
            except Exception as e:
                print("Unexpected Error")
                print("<-----------Error Logs---------->")
                print("Error trying to search for: " + movie_title)
                print("Google Generated Page: " + search_query)
                print("IMDb Google Linked Page: " + link_string)
                print("This is Error Numer: " + str(error_counter))
                logging.error(traceback.format_exc())
                print()
                error_counter = error_counter + 1
                if error_counter == 20:
                    raise

    def parsePage(self):
        content = self.driver.page_source
        soup = BeautifulSoup(content, "html.parser")
        soup.find("div", class_="infobar")
        print(soup.prettify)

    def close(self):
        self.driver.close()

if __name__ == "__main__":
    run_instance = ScrapeInfo()
    #run_instance.main()
    try:
        run_instance.main()
    except:
        print("Unexpected error:", sys.exc_info()[0])
        run_instance.close()
        raise
