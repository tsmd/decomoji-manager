module Decomojis
  class TagsController < ApplicationController
    def update
      @decomoji = Decomoji.find(params[:decomoji_id])
      @decomoji.tag_ids = params[:tag_ids]
      @decomoji.save
      redirect_to @decomoji, status: :see_other
    end
  end
end
