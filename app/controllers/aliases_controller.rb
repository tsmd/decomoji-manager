class AliasesController < ApplicationController
  def new
    @decomoji = Decomoji.find(params[:decomoji_id])
    @alias = @decomoji.aliases.build
  end

  def create
    @decomoji = Decomoji.find(params[:decomoji_id])
    @alias = @decomoji.aliases.build(alias_params)

    if @alias.save
      redirect_to decomoji_path(@decomoji)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    @alias = Alias.find(params[:id])
    @decomoji = @alias.decomoji
    @alias.destroy

    redirect_to decomoji_path(@decomoji)
  end

  private

  def alias_params
    params.require(:alias).permit(:name)
  end
end
