class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :logged_in, except: %i[ index]
  before_action :is_user, only: %i[ show edit update destroy ]
  before_action :check_new, only: %i[create]
  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    if(params[:id] != nil)
      @post.user_id=Integer(params[:id])
      @user=User.find(Integer(params[:id]))
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { render :show22, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def logged_in
      if(session[:user_id])
        return true
      else
        redirect_to main_path, notice: "Please login."
      end
    end

    def is_user
      if(session[:user_id] != @post.user_id)
        redirect_to main_path, notice: "Log in with wrong user"
      else
        return true
      end
    end

    def check_new
      if(session[:user_id] != Integer(post_params["user_id"]))
        redirect_to main_path, notice: "Log in with wrong user"
      else
        return true
      end
    end
      
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:user_id, :msg, :postDate)
    end
end
