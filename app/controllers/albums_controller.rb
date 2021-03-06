class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate

  # Password needed to change any of this
  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'igp' && password == 'ehkra!Q2w#e'
    end
  end

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # GET /albums/sync
  def sync
    vimeo_albums = Vimeo::Simple::User.albums("coloradoigp")
    vimeo_albums.each { |vimeo_album|
      if Album.where(:name => vimeo_album["title"]).blank?
        album = Album.new
        album.name = vimeo_album["title"]
        album.description = vimeo_album["description"]
        album.save
        $album = album
      else
        $album = Album.where(:name => vimeo_album["title"]).take
      end
      videos = Vimeo::Simple::Album.videos(vimeo_album["id"])
      videos.each { |video_info|
        if Video.where(:vid => video_info["id"]).blank?
          video = $album.videos.create(name: video_info["title"], vid: video_info["id"], description: video_info["description"], date: video_info["upload_date"], thumb: video_info["thumbnail_large"])
          video.save
        end
      }
    }
    redirect_to albums_url
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render action: 'show', status: :created, location: @album }
      else
        format.html { render action: 'new' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:name, :description)
    end
end
