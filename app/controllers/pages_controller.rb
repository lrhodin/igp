class PagesController < ApplicationController

  # get pages/library
  def library
    @albums = Video.uniq.pluck(:album)
    if params[:album]
      @videos = Video.where(Album: params[:album])
      @album = params[:album]
    elsif params[:search]
      @videos = Video.where("name like ?", "%#{params[:search]}%")
    else
      @videos = Video.all
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

end
