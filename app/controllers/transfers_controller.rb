class TransfersController < ApplicationController
  def show
    user = User.find(params[:user_id])
    tx = user.transfers.find(params[:id])
    render json: tx.attributes.slice(
      "account_number_from",
      "account_number_to",
      "amount_pennies",
      "country_code_from",
      "country_code_to",
    )
  end
end
