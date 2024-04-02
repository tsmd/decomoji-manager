class DecomojiChecksController < ApplicationController
  def update
    @check = Check.find(params[:check_id])
    @decomoji_check = DecomojiCheck.find(params[:id])
    @decomoji_check.update!(status: params[:status])

    # unchecked なデコモジがなくなったらステータスを変更
    if @check.decomoji_checks.where(status: 'unchecked').empty?
      @check.update!(status: 'completed')
      redirect_to check_path(@decomoji_check.check)
      return
    end

    redirect_to review_check_path(@decomoji_check.check)
  end
end
