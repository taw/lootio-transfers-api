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

  def create
    user = User.find(params[:user_id])
    user.transfers.create(transfer_params).save!
    render json: {result: "ok"}
  end

  def destroy
    user = User.find(params[:user_id])
    tx = user.transfers.find(params[:id])
    tx.delete
    render json: {result: "ok"}
  end

  def update
    user = User.find(params[:user_id])
    tx = user.transfers.find(params[:id])
    tx.update(transfer_params)
    tx.save!
    render json: {result: "ok"}
  end

  private

  def transfer_params
    params.permit(
      :account_number_from,
      :account_number_to,
      :amount_pennies,
      :country_code_from,
      :country_code_to,
    )
  end
end
