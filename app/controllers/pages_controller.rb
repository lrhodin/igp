class PagesController < ApplicationController
  def library
    @albums = Video.uniq.pluck(:album)
    if params[:album]
      @videos = Video.where(Album: params[:album])
      @album = params[:album]
    else
      @videos = Video.all
    end
  end
end
