class GrossRankingController < ApplicationController
  def index
  	@gross = FinancialDatum.all
  	@days = FinancialDatum.uniq.pluck(:date).sort

  end

 
end
