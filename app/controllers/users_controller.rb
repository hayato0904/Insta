class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  def new
       @user = User.new

      # if params[:back]
      #   @user = User.new(user_params)
      # else
      #   @user = User.new
      # end
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(id: @user.id)
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation,:image, :image_cache)
  end
end
