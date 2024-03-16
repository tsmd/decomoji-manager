class DecomojisController < ApplicationController
  def index
    @decomojis = Decomoji.all
  end

  def show
    @decomoji = Decomoji.find(params[:id])
    @all_tags = Tag.where.not(id: @decomoji.tags.select(:id)).order(:name)
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

  def edit
    @decomoji = Decomoji.find(params[:id])
  end

  def update
    @decomoji = Decomoji.find(params[:id])

    if @decomoji.update(decomoji_params)
      redirect_to @decomoji
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @decomoji = Decomoji.find(params[:id])
    @decomoji.destroy

    redirect_to decomojis_path
  end

  def add_tag
    @decomoji = Decomoji.find(params[:id])
    tag_name = params[:tag_name]
    tag = Tag.find_or_create_by(name: tag_name)
    @decomoji.tags << tag unless @decomoji.tags.include?(tag)
    redirect_to @decomoji
  end

  def remove_tag
    @decomoji = Decomoji.find(params[:id])
    tag = Tag.find(params[:tag_id])
    @decomoji.tags.delete(tag)
    redirect_to @decomoji
  end

  private

  def decomoji_params
    params.require(:decomoji).permit(:name, :yomi, :version_id)
  end
end
