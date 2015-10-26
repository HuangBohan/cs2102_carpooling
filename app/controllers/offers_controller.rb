class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy, :request_offer]

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.get_all_offers
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
  end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  # POST /offers.json
  def create
    ids = Offer.new_offer(offer_params)
    @offer = Offer.get_offer(ids[0], ids[1])
    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer, notice: 'Offer was successfully created.' }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    respond_to do |format|
      if Offer.update_offer(offer_params, @paramss[0], @paramss[1])
        format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    Offer.destroy_offer(@paramss[0], @paramss[1])
    respond_to do |format|
      format.html { redirect_to offers_url, notice: 'Offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def request_offer
    @request = Request.new
    @request.requester_username = current_user.username
    @request.offer_datetime = @offer.datetime
    @request.offer_car_license_plate_number = @offer.car_license_plate_number
    @request.save
    respond_to :js
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @paramss = params[:id].split(',')
      @offer = Offer.get_offer(@paramss[0], @paramss[1])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:offer).permit(:datetime,
                                    :pickUpPoint, :dropOffPoint, :vacancies, :car_license_plate_number, :cost)
    end
end
