class VersionsController < ApplicationController
  def index
    @versions = Version.ordered_by_gem_version
    @new_version = Version.new
  end

  def create
    @new_version = Version.new(version_params)
    if @new_version.save
      redirect_to versions_path
    else
      @versions = Version.ordered_by_gem_version
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @version = Version.find(params[:id])
  end

  def update
    @version = Version.find(params[:id])
    if @version.update(version_params)
      redirect_to versions_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @version = Version.find(params[:id])
    @version.destroy
    redirect_to versions_path, status: :see_other
  end

  private

  def version_params
    params.require(:version).permit(:name)
  end
end
