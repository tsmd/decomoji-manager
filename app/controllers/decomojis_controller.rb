class DecomojisController < ApplicationController
  def index
    @decomojis = Decomoji.all
  end

  def show
    @decomoji = Decomoji.find(params[:id])
  end
end
