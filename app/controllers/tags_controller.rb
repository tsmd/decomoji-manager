class TagsController < ApplicationController
    def index
      @tags = Tag.order(:name)
      @new_tag = Tag.new
    end
  
    def new
      @tag = Decomoji.new
    end

    def create
      @tag = Tag.new(tag_params)
      if @tag.save
        redirect_to tags_path
      else
        @tags = Tag.order(:name)
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @tag = Tag.find(params[:id])
    end
  
    def update
      @tag = Tag.find(params[:id])
      if @tag.update(tag_params)
        redirect_to tags_path
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @tag = Tag.find(params[:id])
      @tag.destroy
      redirect_to tags_path, status: :see_other
    end
  
    private
  
    def tag_params
      params.require(:tag).permit(:name)
    end
  end
  