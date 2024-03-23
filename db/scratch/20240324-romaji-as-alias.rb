# ローマ字表記をエイリアスとして全デコモジに適用

require 'csv'

include RomajiKanaConverter

Decomoji.find_each do |decomoji|
  # decomoji.to_hepburn と decomoji.to_kunrei から文字列を取得
  hepburn = decomoji.yomi_hepburn
  kunrei = decomoji.yomi_kunrei

  # ２つのメソッドから得られる文字列が同一でない場合、または同名のエイリアスが存在しない場合に登録
  if hepburn != kunrei && !decomoji.aliases.exists?(name: kunrei)
    decomoji.aliases.create(name: kunrei)
  end

  # hepburnに対しても同様のチェックを行い、条件に合致する場合に登録
  if !decomoji.aliases.exists?(name: hepburn)
    decomoji.aliases.create(name: hepburn)
  end
end
