class FinancialDataController < ApplicationController
  before_action :set_financial_datum, only: [:show, :edit, :update, :destroy]

  # GET /financial_data
  # GET /financial_data.json
  def index
    @financial_data = FinancialDatum.all
  end

  # GET /financial_data/1
  # GET /financial_data/1.json
  def show
      @financial_datum = FinancialDatum.find(params[:id])
  end

  # GET /financial_data/new
  def new
    @financial_datum = FinancialDatum.new
  end

  # GET /financial_data/1/edit
  def edit
  end

  # POST /financial_data
  # POST /financial_data.json
  def create
    @financial_datum = FinancialDatum.new(financial_datum_params)

    respond_to do |format|
      if @financial_datum.save
        format.html { redirect_to @financial_datum, notice: 'Financial datum was successfully created.' }
        format.json { render :show, status: :created, location: @financial_datum }
      else
        format.html { render :new }
        format.json { render json: @financial_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /financial_data/1
  # PATCH/PUT /financial_data/1.json
  def update
    respond_to do |format|
      if @financial_datum.update(financial_datum_params)
        format.html { redirect_to @financial_datum, notice: 'Financial datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @financial_datum }
      else
        format.html { render :edit }
        format.json { render json: @financial_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /financial_data/1
  # DELETE /financial_data/1.json
  def destroy
    @financial_datum.destroy
    respond_to do |format|
      format.html { redirect_to financial_data_url, notice: 'Financial datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_financial_datum
      @financial_datum = FinancialDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def financial_datum_params
      params.fetch(:financial_datum, {})
    end
end
