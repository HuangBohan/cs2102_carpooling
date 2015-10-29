class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy, :request_offer]

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.search_offers(params[:keyword],
      params[:pick_up_point], params[:drop_off_point],
      params[:vancancy_lower_limit], params[:vancancy_upper_limit],
      params[:cost_lower_limit], params[:cost_upper_limit])
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
    @offer = Offer.get_offer(ids[0], ids[1]) if ids
    #HACK
    @offer = Offer.create(offer_params) unless ids
    respond_to do |format|
      if ids
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
    ids = Offer.update_offer(offer_params, @paramss[0], @paramss[1])
    @offer.update(offer_params) unless ids
    respond_to do |format|
      if ids
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
    @request.request_datetime = Time.now
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
