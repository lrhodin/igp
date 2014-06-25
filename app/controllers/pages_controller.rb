class PagesController < ApplicationController

  # get most recent 9 videos for homepage mosaic
  def home
    @videos = Video.order("date DESC")
    @recentvids = @videos[0...9]
  end


  # get pages/library
  def library
    @albums = Video.uniq.pluck(:album)
    if params[:album]
      @videos = Video.where(Album: params[:album])
      @album = params[:album]
    elsif params[:search]
      @videos = Video.where("name like ?", "%#{params[:search]}%")
    else
      @videos = Video.order("date DESC")
    end
  end

  # get pages/viewer
  def viewer
    if params[:video_id]
      @video_id = params[:video_id]
    else
      redirect_to "/pages/library"
    end
  end

  def video
    respond_to do |format|
      format.html { redirect_to "pages/viewer" }
      format.js
    end
  end

  #putting in static pages just for clarity's sake
  def supporters
    render 'supporters'
  end

  def staff
    render 'staff'
  end

end
