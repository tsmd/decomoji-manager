class DecomojisController < ApplicationController
  def index
    @decomojis = Decomoji.all
  end

  def show
    @decomoji = Decomoji.find(params[:id])
  end

  def new
    @decomoji = Decomoji.new
  end

  def create
    @decomoji = Decomoji.new(decomoji_params)
    if @decomoji.save
      redirect_to @decomoji
    else
      render "new", status: :unprocessable_entity
    end
  end

  private

  def decomoji_params
    params.require(:decomoji).permit(:name, :yomi, :version_id)
  end
end
