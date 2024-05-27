class TagsController < ApplicationController
  def index
    @tags = Tag.order(:name)
    @new_tag = Tag.new
  end

  def create
    @new_tag = Tag.new(tag_params)
    if @new_tag.save
      redirect_to tags_path
    else
      @tags = Tag.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @tag = Tag.find(params[:id])
    @turbo_frame_request = turbo_frame_request?
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      redirect_to tags_path, flash: { tag_updated: @tag.id }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tags_path, status: :see_other
  end

  def turbo_frame_request?
    request.headers['Turbo-Frame'].present?
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :description)
  end
end
