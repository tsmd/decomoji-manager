class BatchesController < ApplicationController
  def new
  end

  def confirm
    tsv_data = params[:decomojis]
    @decomojis = []
    @errors = []
    next_color = Decomoji.last&.color_id

    # TSVデータを行ごとに処理
    tsv_data.each_line do |line|
      name, yomi = line.chomp.split("\t")
      decomoji = Decomoji.new(
        name: name,
        yomi: yomi,
        font: Decomoji.default_font(name),
      )

      if decomoji.valid?
        next_color = Decomoji.next_color_id(next_color)
        decomoji.color_id = next_color
        @decomojis << decomoji
      else
        @errors << { name: name, errors: decomoji.errors.full_messages }
      end
    end
  end

  def create
    Decomoji.create!(decomoji_params)
    redirect_to root_path, status: :see_other
  end

  private

  def decomoji_params
    params.require(:decomojis).map do |decomoji|
      decomoji.permit(:name, :yomi, :font, :color_id)
    end
  end
end
