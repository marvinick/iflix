class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)
    if @video.save
      flash[:success] = "You have added a video '#{@video.title}'"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Something's wrong. Please check your inputs"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover, :video_url)
  end

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that"
      redirect_to home_path
    end
  end
end