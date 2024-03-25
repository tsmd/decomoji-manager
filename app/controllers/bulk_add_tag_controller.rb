class BulkAddTagController < ApplicationController
  def new
    @ids = params[:ids]
    @all_tags = Tag.order(:name)
  end

  def create
    Decomoji.transaction do
      Decomoji.where(id: params[:ids]).each do |decomoji|
        tag = Tag.find_or_create_by(name: params[:tag_name])
        decomoji.tags << tag unless decomoji.tags.include?(tag)
      end
    end
    redirect_to decomojis_path
  end
end
