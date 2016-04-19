#!bin/python3

from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.keys import Keys




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
    def __init__(self):
        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(3)
        self.driver.get("http://www.the-numbers.com/daily-box-office-chart")
        self.driver.implicitly_wait(10)


    def main(self):
        soup_data = self.getChartData()
        self.parseData(soup_data)
        self.driver.get("http://www.imdb.com/")
        self.driver.implicitly_wait(10)
        self.getMovieInfo()
        #print(self.movie_data)
        #self.driver_movie_info.close()
        self.driver.close()

    def getChartData(self):
        content = self.driver.page_source
        soup = BeautifulSoup(content, "html.parser")
        return soup

    def removeWhitSpace(self, text):
        return text.replace(u'\xa0', u' ').strip()

    def stripForNumOnly(self, text):
        stripped_text = self.removeWhitSpace(text)
        ret = ''.join(filter(lambda x: x.isdigit(), stripped_text))
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
            change         = self.stripForNumOnly(data[5].text)
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
            print(movie_title)
            inputElement = self.driver.find_element_by_id("navbar-query")
            inputElement.send_keys(movie_title)
            inputElement.send_keys(Keys.ENTER)
            self.parsePage()

    def parsePage(self):
        content = self.driver.page_source
        soup = BeautifulSoup(content, "html.parser")
        soup.find("div", class_="infobar")
        print(soup.prettify)

    def close(self):
        self.driver.close()

if __name__ == "__main__":
    run_instance = ScrapeInfo()
    try:
        run_instance.main()
    except:
        run_instance.close()
