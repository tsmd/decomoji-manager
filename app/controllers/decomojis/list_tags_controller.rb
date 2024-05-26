module Decomojis
  class ListTagsController < ApplicationController
    def show
      @decomoji = Decomoji.find(params[:decomoji_id])
      @tags = @decomoji.tags.pluck(:name).join(', ')
      @turbo_frame_request = turbo_frame_request?
    end

    def edit
      @decomoji = Decomoji.find(params[:decomoji_id])
      @tags = @decomoji.tags.pluck(:name).join(', ')
      @all_tags = Tag.where.not(id: @decomoji.tags.select(:id)).order(:name)
    end

    def create
      @decomoji = Decomoji.find(params[:decomoji_id])
      tag_names = params[:tags].split(',').map(&:strip).reject(&:blank?)

      if tag_names.empty?
        redirect_to decomoji_list_tags_path(@decomoji), status: :see_other
        return
      end

      tag_names.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        @decomoji.tags << tag unless @decomoji.tags.include?(tag)
      end

      redirect_to edit_decomoji_list_tags_path(@decomoji), status: :see_other
    end

    def destroy
      @decomoji = Decomoji.find(params[:decomoji_id])
      tag = Tag.find(params[:id])
      @decomoji.tags.delete(tag)

      redirect_to edit_decomoji_list_tags_path(@decomoji), status: :see_other
    end

    private

    def turbo_frame_request?
      request.headers['Turbo-Frame'].present?
    end
  end
end
