class TokensController < ApplicationController
  def create
    user = User.find(params[:user_id])
    password = params[:password]
    if user.verify_password(password)
      token = user.tokens.create
      render json: {token: token.id}
    else
      render json: {error: "Bad password"}, status: 500
    end
  end
end
