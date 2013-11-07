class PagesController < ApplicationController
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
end
