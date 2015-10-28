class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :approve]

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
    @request.requester_username = current_user.username
  end

  # POST /requests
  # POST /requests.json
  def create
    status = Request.new_request(request_params)
    @request = Request.get_request(status[0], status[1], status[2]) if status
    respond_to do |format|
      if status
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    User.transaction do
      Request.approve_request(@paramss[0], @paramss[1], @paramss[2])
    end
    redirect_to offers_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @paramss= params[:id].split(',')
      @request = Request.get_request(@paramss[0], @paramss[1], @paramss[2])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params[:requester_uswername] = current_user.username
      params.require(:request).permit(:status, :offer_datetime, :offer_car_license_plate_number, :requester_uswername)
    end
end
