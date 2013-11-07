class PagesController < ApplicationController
  def library
    if params[:album]
      @videos = Video.where(Album: params[:album])
    else
      @videos = Video.all
    end
  end
end
