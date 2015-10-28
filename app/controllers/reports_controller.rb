class ReportsController < ApplicationController
  def user_offers
    @users = User.user_offers_report
  end

  def popular_pickup
    @points = Offer.popular_pickup_points
  end

  def popular_dropoff
    @points = Offer.popular_dropoff_points
  end
end
