class PagesController < ApplicationController
  def library
    @videos = Video.all
  end
end
