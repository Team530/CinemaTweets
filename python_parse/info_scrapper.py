#!bin/python3

import datetime, time
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


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
    year = datetime.datetime.now().year
    GOOGLE_SEARCH_STRING = "https://www.google.com/search?q="
    def __init__(self):

        profile = webdriver.FirefoxProfile("/home/christopher/.mozilla/firefox/m3hrfqdg.default")
        self.driver = webdriver.Firefox(profile)
        self.driver.implicitly_wait(3)
        self.driver.get("http://www.the-numbers.com/daily-box-office-chart")
        self.driver.implicitly_wait(10)


    def main(self):
        soup_data = self.getSoupData()
        self.parseData(soup_data)
        self.getMovieInfo()
        #print(self.movie_data)
        #self.driver_movie_info.close()
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

    def stripTime(self, text):
        stripped_text = self.removeWhitSpace(text)
        return stripped_text

    def stripForPercent(self, text):
        stripped_text = self.removeWhitSpace(text)
        ret = ''.join(filter(lambda x: x.isdigit() or x is "+" or x is "-", stripped_text))
        if not ret:
            return "-"
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
        for movie_title in self.movie_data:
            time.sleep(3)
            search_query = self.GOOGLE_SEARCH_STRING + str(movie_title) + " IMDb " + str(self.year)
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
                    movie_classificaiton = soup_data.find(itemprop="contentRating")['content']
                    #year = soup.find(itemprop="name").get_text()
                    movie_duration = self.stripTime(soup_data.find(itemprop="duration").get_text())
                    movie_genres = soup_data.findAll('span',itemprop="genre")
                    if not IMDb_movie_title:
                        print("Unable to get movie title")
                        continue
                    print(IMDb_movie_title)
                    print(movie_classificaiton)
                    print(movie_duration)
                    print(movie_genres)
                    print()


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
    #try:
    run_instance.main()
    #except:
    #    run_instance.close()


"""
        for movie_title in self.movie_data:
            self.driver.get("https://www.google.com/?gws_rd=ssl")
            self.driver.implicitly_wait(10)
            print(self.driver.page_source)

            inputElement = self.driver.find_element_by_id("lst-ib")
            search_term = str(movie_title) + " IMDb " + str(self.year)
            inputElement.send_keys(search_term)
            inputElement.send_keys(Keys.ENTER)
            time.sleep(10)
            soup_data = self.getSoupData()
            print(self.driver.page_source)
            print()
            result_class = soup_data.find_all("div", _class="rc")
            print(result_class)
            print(result_class.find_all("a"))
            print()
            time.sleep(10)
            #result.find_element_by_xpath("./div/h3/a").click()
            #print(result)
            #self.parsePage()
    """
