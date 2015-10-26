class CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy]

  # GET /cars
  # GET /cars.json
  def index
    if current_user.isAdmin?
      @cars = Car.all_cars_search(params[:search])
    else
      @cars = Car.user_cars_search(current_user.username, params[:search])
    end
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
  end

  # POST /cars
  # POST /cars.json
  def create
    new_car = Car.new_car(car_params)
    car = Car.get_car(new_car)
    # HACK
    @car = Car.create(car_params) unless new_car
    respond_to do |format|
      if new_car
        format.html { redirect_to @car, notice: 'Car was successfully created.' }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    update_car = Car.update_car(car_params, params[:id])
    # HACK
    @car.update(car_params) unless update_car
    respond_to do |format|
      if update_car
        format.html { redirect_to @car, notice: 'Car was successfully updated.' }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    Car.destroy_car(params[:id])
    respond_to do |format|
      format.html { redirect_to cars_url, notice: 'Car was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.get_car(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params[:car][:owner_username] = current_user.username
      params.require(:car).permit(:name, :seats, :owner_username, :license_plate_number)
    end
end
