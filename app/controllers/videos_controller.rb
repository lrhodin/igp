class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # GET /videos/sync
  def sync
    albums = Vimeo::Simple::User.albums("coloradoigp")
    albums.each { |album|
      album_name = album["title"]
      videos = Vimeo::Simple::Album.videos(album["id"])
      videos.each { |video_info|
        if Video.where(:vid => video_info["id"]).blank?
          video = Video.new
          video.name = video_info["title"]
          video.vid = video_info["id"]
          video.description = video_info["description"]
          video.date = video_info["upload_date"]
          video.thumb = video_info["thumbnail_medium"]
          video.album = album_name
          video.save
        end
      }
    }

    redirect_to videos_url
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    video_info = Vimeo::Simple::Video.info(@video.vid)
    @video.name = video_info[0]["title"]
    @video.description = video_info[0]["description"]
    @video.date = video_info[0]["upload_date"]
    @video.thumb = video_info[0]["thumbnail_medium"]

    respond_to do |format|
      if @video.save
        format.html { redirect_to videos_url, notice: 'Video was successfully created.' }
        format.json { render action: 'show', status: :created, location: @video }
      else
        format.html { render action: 'new' }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:name, :description, :thumb, :date, :vid)
    end
end
