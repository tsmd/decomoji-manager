class ChecksController < ApplicationController
  def new
    @check = Check.new
    @check.name = DateTime.now.strftime('%Y-%m-%d %H:%M')
    @decomoji_ids = params[:ids]
    @decomojis = Decomoji.where(id: @decomoji_ids)
  end

  def create
    @check = Check.new(check_params)
    if @check.save
      params[:ids].each do |decomoji_id|
        DecomojiCheck.create(decomoji_id: decomoji_id, check_id: @check.id, status: 'unchecked')
      end
      redirect_to @check
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @checks = Check.order(created_at: :desc)
  end

  def show
    @check = Check.find(params[:id])

    @unchecked_checks = @check.decomoji_checks.includes(decomoji: :color).where(status: 'unchecked')
    @problem_checks = @check.decomoji_checks.includes(decomoji: :color).where(status: 'problem')
    @ok_checks = @check.decomoji_checks.includes(decomoji: :color).where(status: 'ok')
  end

  def review
    @check = Check.find(params[:id])
    @count = @check.decomoji_checks.size

    @unchecked_checks = @check.decomoji_checks.includes(decomoji: :color).where(status: 'unchecked')
    @problem_checks = @check.decomoji_checks.includes(decomoji: :color).where(status: 'problem')
    @ok_checks = @check.decomoji_checks.includes(decomoji: :color).where(status: 'ok')

    @target_check = @unchecked_checks&.first
  end

  private

  def check_params
    params.require(:check).permit(:name)
  end
end
