class PagesController < ApplicationController
  # get most recent 9 videos for homepage mosaic
  def home
    @videos = Video.order("date DESC")
    @recentvids = @videos[0...9]
  end


  # get pages/library
  def library
    @albums = Video.uniq.pluck(:album).sort()
    if params[:album]
      if params[:sort]
        if params[:sort] == 'date'
          @videos = Video.where(Album: params[:album]).order("date desc")
          @album = params[:album]
        elsif params[:sort] == 'title'
          @videos = Video.where(Album: params[:album]).order("name asc")
          @album = params[:album]
        else
          @videos = Video.where(Album: params[:album])
          @album = params[:album]
        end
      else
        @videos = Video.where(Album: params[:album])
        @album = params[:album]
      end
    elsif params[:search]
      # Split search string into keywords
      @keywords = params[:search].strip.split(/\s+/).uniq
      @videos = []
      @found_videos = []

      # Match each keyword
      @keywords.each do |keyword|
        @found_videos = @found_videos.concat Video.where("(description like ? OR name like ?)", "%" + keyword + "%", "%" + keyword + "%")
        @videos = @found_videos.flatten.group_by{|x| x}.sort_by{|k, v| -v.size}.map(&:first)
      end
    elsif params[:sort]
      if params[:sort] == 'date'
        @videos = Video.order("date DESC")
      elsif params[:sort] == 'title'
        @videos = Video.order("name ASC")
      end
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

  #replace thumbnail with vimeo player when user clicks thumb
  def video
    respond_to do |format|
      format.html { redirect_to "pages/viewer" }
      format.js
    end
  end

  #put thumbnail back if vimeo player closed
  def close_video
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
