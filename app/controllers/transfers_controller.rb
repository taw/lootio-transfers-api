class TransfersController < ApplicationController
  before_action :load_user!
  before_action :verify_token!

  def show
    tx = @user.transfers.find(params[:id])
    render json: tx.attributes.slice(
      "account_number_from",
      "account_number_to",
      "amount_pennies",
      "country_code_from",
      "country_code_to",
    )
  end

  def create
    @user.transfers.create(transfer_params).save!
    render json: {result: "ok"}
  end

  def destroy
    tx = @user.transfers.find(params[:id])
    tx.delete
    render json: {result: "ok"}
  end

  def update
    tx = @user.transfers.find(params[:id])
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

  def load_user!
    @user = User.find(params[:user_id])
  end

  def verify_token!
    @user.tokens.find(params[:token_id])
  end
end
