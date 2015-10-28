class ReportsController < ApplicationController
  def user_offers
    @users = User.user_offers_report
  end
end
