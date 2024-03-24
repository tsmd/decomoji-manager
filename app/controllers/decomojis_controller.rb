class DecomojisController < ApplicationController
  include Pagy::Backend

  def index
    search_result = search_decomojis(params[:search])
    @pagy, @decomojis = pagy(search_result, items: 1000, size: [1, 6, 6, 1])
    @count = search_result.count
  end
  
  def search_decomojis(search)
    all = Decomoji.includes(:color, image_attachment: :blob).all
    return all if search.blank?

    tokens = search.split
    tokens.inject(all) do |scope, token|
      if token.start_with?('tag:')
        tag_name = token.delete_prefix('tag:')
        scope.joins(:tags).where(tags: { name: tag_name })
      elsif token.start_with?('version:')
        version_name = token.delete_prefix('version:')
        scope.joins(:version).where(versions: { name: version_name })
      elsif token.start_with?('color:')
        color_name = token.delete_prefix('color:')
        scope.joins(:color).where(colors: { name: color_name })
      else
        token = token.tr('ァ-ン', 'ぁ-ん')
        scope.left_joins(:aliases)
             .where('decomojis.name LIKE ? OR decomojis.yomi LIKE ? OR aliases.name LIKE ?', "%#{token}%", "%#{token}%", "%#{token}%")
             .distinct
      end
    end
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
    params.require(:decomoji).permit(:name, :yomi, :image, :color_id, :version_id)
  end
end
