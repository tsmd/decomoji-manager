require 'csv'

class DecomojisController < ApplicationController
  include ActionController::Live
  include Pagy::Backend

  def index
    respond_to do |format|
      format.html do
        if session[:display_mode] == 'list'
          redirect_to list_path(search: params[:search], page: params[:page])
        else
          redirect_to grid_path(search: params[:search], page: params[:page])
        end
      end

      format.json do
        response.headers['Content-Type'] = 'application/json; charset=utf-8'
        response.stream.write '['
        search_result = search_decomojis(params[:search])
        search_result.find_each.with_index do |decomoji, i|
          response.stream.write ',' unless i.zero?
          response.stream.write decomoji.as_json.to_json
        end
        response.stream.write ']'
        response.stream.close
      end

      format.csv do
        response.headers['Content-Type'] = 'text/csv; charset=utf-8'
        response.stream.write CSV.generate_line(Decomoji.row_header)
        search_result = search_decomojis(params[:search])
        search_result.find_each do |decomoji|
          response.stream.write CSV.generate_line(decomoji.as_row)
        end
        response.stream.close
      end

      format.tsv do
        response.headers['Content-Type'] = 'text/tab-separated-values; charset=utf-8'
        response.stream.write CSV.generate_line(Decomoji.row_header, col_sep: "\t")
        search_result = search_decomojis(params[:search])
        search_result.find_each do |decomoji|
          response.stream.write CSV.generate_line(decomoji.as_row, col_sep: "\t")
        end
        response.stream.close
      end
    end
  end

  def grid
    search_result = search_decomojis(params[:search])
    @pagy, @decomojis = pagy(search_result, items: 500, size: [1, 3, 3, 1])
    @count = search_result.count

    session[:display_mode] = 'grid'

    render layout: 'decomoji_list'
  end

  def list
    search_result = search_decomojis(params[:search])
    @pagy, @decomojis = pagy(search_result, items: 500, size: [1, 3, 3, 1])
    @count = search_result.count

    session[:display_mode] = 'list'

    render layout: 'decomoji_list'
  end

  def search_decomojis(search)
    all = Decomoji.preload(:tags, :aliases).eager_load(:color, :version, image_attachment: :blob).all
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
    params.require(:decomoji).permit(:name, :yomi, :image, :font, :color_id, :version_id)
  end
end
