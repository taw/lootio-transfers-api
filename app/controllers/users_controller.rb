class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render json: {
      name: user.name,
      age: user.age,
    }
  end

  def destroy
    user = User.find(params[:id])
    user.delete
    render json: {result: "ok"}
  end

  def create
    User.create(user_params).save!
    render json: {result: "ok"}
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    user.save!
    render json: {result: "ok"}
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :address_line_1, :DOB)
  end
end
