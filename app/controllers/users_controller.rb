class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  @fLogin = false 

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_fast
    @name =params[:name]
    @email = params[:email]
    User.create(name: @name, email: @email)
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    
    respond_to do |format|
      format.html { render :destroy , notice: "User was successfully destroyed." }
      format.json { render :show, status: :destroy, location: @user }
      #format.json { head :no_content }
    end
    @user.destroy
  end

  def main
    if @fLogin
      @user = User.find_by(email: @email)
    else
      @user = User.new
    end
  end

  def nmain
    @email = params[:email]
    @password =params[:password]
    @user = User.find_by(email: @email)
    respond_to do |format|
      if @user != nil 
        if @user.password == @password
          format.html { render :showUser, notice: "User was successfully updated." }
          format.json { render :showUser, status: :ok, location: @user }
        else 
          @fLogin = true
          @user.errors.add  :name, :too_plain,message: "Wrong password"
          format.html { render :main, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        @fLogin = true
        @user = User.new
        @user.errors.add  :name, :too_plain,message: "No email"
        format.html { render :main, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :birthday, :address, :postal_code, :password)
    end

end
