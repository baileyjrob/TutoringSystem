class UsersController < ApplicationController
    def index  
        @users = User.all
    end
    
    def show
        @user = User.find(params[:id])
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            redirect_to @user
        else
            render :new
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])

        if @user.update(user_params)
            redirect_to root_path, notice: ("User \"".concat(@user.title.concat("\" was updated")))
        else
            render :edit
        end
    end

    def destroy
        @user = User.find(params[:id])
        if params[:confirm] == "1"
            @user.destroy
            redirect_to root_path, notice: ("User \"".concat(@user.title.concat("\" was deleted")))
        end
    end

    private
        def user_params
            params.require(:user).permit(:title, :author, :genre, :price, :published_date)
        end
end
