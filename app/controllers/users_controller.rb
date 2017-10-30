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
  end

  def create
    User.create(user_params)
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :address_line_1, :DOB)
  end
end
