class UsersController < ApplicationController

  def show
    user = User.find(params[:id])
    render json: {
      name: user.name,
      age: user.age,
    }
  end
end
