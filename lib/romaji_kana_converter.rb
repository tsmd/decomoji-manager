require 'nkf'

module RomajiKanaConverter
  HEPBURN_1 = {
    'か' => 'ka', 'き' => 'ki',  'く' => 'ku',  'け' => 'ke', 'こ' => 'ko',
    'さ' => 'sa', 'し' => 'shi', 'す' => 'su',  'せ' => 'se', 'そ' => 'so',
    'た' => 'ta', 'ち' => 'chi', 'つ' => 'tsu', 'て' => 'te', 'と' => 'to',
    'な' => 'na', 'に' => 'ni',  'ぬ' => 'nu',  'ね' => 'ne', 'の' => 'no',
    'は' => 'ha', 'ひ' => 'hi',  'ふ' => 'fu',  'へ' => 'he', 'ほ' => 'ho',
    'ま' => 'ma', 'み' => 'mi',  'む' => 'mu',  'め' => 'me', 'も' => 'mo',
    'や' => 'ya',                'ゆ' => 'yu',                'よ' => 'yo',
    'ら' => 'ra', 'り' => 'ri',  'る' => 'ru',  'れ' => 're', 'ろ' => 'ro',
    'わ' => 'wa',                                             'を' => 'wo',
    'ん' => 'nn',

    'ゔ' => 'vu',
    'が' => 'ga', 'ぎ' => 'gi', 'ぐ' => 'gu', 'げ' => 'ge', 'ご' => 'go',
    'ざ' => 'za', 'じ' => 'ji', 'ず' => 'zu', 'ぜ' => 'ze', 'ぞ' => 'zo',
    'だ' => 'da', 'ぢ' => 'di', 'づ' => 'du', 'で' => 'de', 'ど' => 'do',
    'ば' => 'ba', 'び' => 'bi', 'ぶ' => 'bu', 'べ' => 'be', 'ぼ' => 'bo',
    'ぱ' => 'pa', 'ぴ' => 'pi', 'ぷ' => 'pu', 'ぺ' => 'pe', 'ぽ' => 'po',

    'ぁ' => 'xa', 'ぃ' => 'xi', 'ぅ' => 'xu', 'ぇ' => 'xe', 'ぉ' => 'xo',
    'っ' => 'xtsu',
    'ゃ' => 'xya', 'ゅ' => 'xyu', 'ょ' => 'xyo',
    'ゎ' => 'xwa',
  }

  HEPBURN_2 = {
    'きゃ' => 'kya', 'きぃ' => 'kyi', 'きゅ' => 'kyu', 'きぇ' => 'kye', 'きょ' => 'kyo',
    'しゃ' => 'sha', 'しぃ' => 'syi', 'しゅ' => 'shu', 'しぇ' => 'she', 'しょ' => 'sho',
    'ちゃ' => 'cha', 'ちぃ' => 'cyi', 'ちゅ' => 'chu', 'ちぇ' => 'che', 'ちょ' => 'cho',
    'にゃ' => 'nya', 'にぃ' => 'nyi', 'にゅ' => 'nyu', 'にぇ' => 'nye', 'にょ' => 'nyo',
    'ひゃ' => 'hya', 'ひぃ' => 'hyi', 'ひゅ' => 'hyu', 'ひぇ' => 'hye', 'ひょ' => 'hyo',
    'みゃ' => 'mya', 'みぃ' => 'myi', 'みゅ' => 'myu', 'みぇ' => 'mye', 'みょ' => 'myo',
    'りゃ' => 'rya', 'りぃ' => 'ryi', 'りゅ' => 'ryu', 'りぇ' => 'rye', 'りょ' => 'ryo',

    'ぎゃ' => 'gya', 'ぎぃ' => 'gyi', 'ぎゅ' => 'gyu', 'ぎぇ' => 'gye', 'ぎょ' => 'gyo',
    'じゃ' => 'ja',  'じぃ' => 'jyi', 'じゅ' => 'ju',  'じぇ' => 'je',  'じょ' => 'jo',
    'ぢゃ' => 'dya', 'ぢぃ' => 'dyi', 'ぢゅ' => 'dyu', 'ぢぇ' => 'dye', 'ぢょ' => 'dyo',
    'びゃ' => 'bya', 'びぃ' => 'byi', 'びゅ' => 'byu', 'びぇ' => 'bye', 'びょ' => 'byo',
    'ぴゃ' => 'pya', 'ぴぃ' => 'pyi', 'ぴゅ' => 'pyu', 'ぴぇ' => 'pye', 'ぴょ' => 'pyo',

    'うぁ' => 'wha', 'うぃ' => 'wi',  'うぅ' => 'wu',  'うぇ' => 'we',  'うぉ' => 'who',
    'くぁ' => 'kwa', 'くぃ' => 'kwi', 'くぅ' => 'kwu', 'くぇ' => 'kwe', 'くぉ' => 'kwo',
    'すぁ' => 'swa', 'すぃ' => 'swi', 'すぅ' => 'swu', 'すぇ' => 'swe', 'すぉ' => 'swo',
    'つぁ' => 'tsa', 'つぃ' => 'tsi',                  'つぇ' => 'tse', 'つぉ' => 'tso',
    'ぬぁ' => 'nwa', 'ぬぃ' => 'nwi', 'ぬぅ' => 'nwu', 'ぬぇ' => 'nwe', 'ぬぉ' => 'nwo',
    'ふぁ' => 'fa',  'ふぃ' => 'fi',  'ふぅ' => 'fwu', 'ふぇ' => 'fe',  'ふぉ' => 'fo',
    'むぁ' => 'mwa', 'むぃ' => 'mwi', 'むぅ' => 'mwu', 'むぇ' => 'mwe', 'むぉ' => 'mwo',
    'るぁ' => 'rwa', 'るぃ' => 'rwi', 'るぅ' => 'rwu', 'るぇ' => 'rwe', 'るぉ' => 'rwo',

    'ぐぁ' => 'gwa', 'ぐぃ' => 'gwi', 'ぐぅ' => 'gwu', 'ぐぇ' => 'gwe', 'ぐぉ' => 'gwo',
    'ずぁ' => 'zwa', 'ずぃ' => 'zwi', 'ずぅ' => 'zwu', 'ずぇ' => 'zwe', 'ずぉ' => 'zwo',
    'づぁ' => 'dsa', 'づぃ' => 'dsi', 'づぅ' => 'dsu', 'づぇ' => 'dse', 'づぉ' => 'dso',
    'ぶぁ' => 'bwa', 'ぶぃ' => 'bwi', 'ぶぅ' => 'bwu', 'ぶぇ' => 'bwe', 'ぶぉ' => 'bwo',
    'ぷぁ' => 'pwa', 'ぷぃ' => 'pwi', 'ぷぅ' => 'pwu', 'ぷぇ' => 'pwe', 'ぷぉ' => 'pwo',

    'てゃ' => 'tha', 'てぃ' => 'thi', 'てゅ' => 'thu', 'てぇ' => 'the', 'てょ' => 'tho',
    'でゃ' => 'dha', 'でぃ' => 'dhi', 'でゅ' => 'dhu', 'でぇ' => 'dhe', 'でょ' => 'dho',

    'とぁ' => 'twa', 'とぃ' => 'twi', 'とぅ' => 'twu', 'とぇ' => 'twe', 'とぉ' => 'two',
    'どぁ' => 'dwa', 'どぃ' => 'dwi', 'どぅ' => 'dwu', 'どぇ' => 'dwe', 'どぉ' => 'dwo',

    'ゔぁ' => 'va', 'ゔぃ' => 'vi', 'ゔぇ' => 've', 'ゔぉ' => 'vo',
  }

  HEPBURN_3 = {
    'あ' => 'a', 'い' => 'i', 'う' => 'u', 'え' => 'e', 'お' => 'o',
    '〜' => '-', '～' => '-', 'ー' => '-',
    '!' => '_', '?' => '_', '_' => '_',
  }

  # ヘボン式との差分のみ記述
  KUNREI_1 = HEPBURN_1.merge({
    'し' => 'si', 'ち' => 'ti', 'つ' => 'tu', 'ふ' => 'hu',
    'じ' => 'zi',

    'ぁ' => 'la', 'ぃ' => 'li', 'ぅ' => 'lu', 'ぇ' => 'le', 'ぉ' => 'lo',
    'っ' => 'ltu',
    'ゃ' => 'lya', 'ゅ' => 'lyu', 'ょ' => 'lyo',
    'ゎ' => 'lwa',
  })

  KUNREI_2 = HEPBURN_2.merge({
    'しゃ' => 'sya', 'しゅ' => 'syu', 'しぇ' => 'sye', 'しょ' => 'syo',
    'ちゃ' => 'tya', 'ちぃ' => 'tyi', 'ちゅ' => 'tyu', 'ちぇ' => 'tye', 'ちょ' => 'tyo',
    'じゃ' => 'zya', 'じぃ' => 'zyi', 'じゅ' => 'zyu', 'じぇ' => 'zye', 'じょ' => 'zyo',
  })

  KUNREI_3 = HEPBURN_3.merge({})

  # キーの文字列長に応じてグループ化する
  inverted_table = {}.merge(HEPBURN_1.invert).merge(HEPBURN_2.invert).merge(HEPBURN_3.invert)
                     .merge(KUNREI_1.invert).merge(KUNREI_2.invert).merge(KUNREI_3.invert)
  KANA = inverted_table.each_with_object({}) do |(key, value), result|
    length = key.length
    result[length] ||= {}
    result[length][key] = value
  end
  KANA[1]['n'] = 'ん'

  def to_hepburn_romaji(str)
    to_romaji(str, HEPBURN_1, HEPBURN_2, HEPBURN_3)
  end

  def to_kunrei_romaji(str)
    to_romaji(str, KUNREI_1, KUNREI_2, KUNREI_3)
  end

  def to_kana(romaji)
    pointer = 0
    kana = ''

    # 促音を事前処理
    romaji = romaji.gsub(/([bcdfghjklmprstvwxyz])(\1)/, 'っ\\2')

    while pointer < romaji.length
      matched = false

      # Try to match the longest possible romaji sequence first
      [4, 3, 2, 1].each do |length|
        next if pointer + length > romaji.length
        slice = romaji[pointer, length]

        if KANA[length].has_key?(slice)
          kana += KANA[length][slice]
          pointer += length
          matched = true
          break
        end
      end

      # Move the pointer forward if no match was found
      unless matched
        kana += romaji[pointer]
        pointer += 1 
      end
    end

    kana
  end

  def to_kana_adjusted(str, original)
    # 正規化
    str = str.downcase
    original = NKF.nkf('-w -W -Z', original)

    # originalからアルファベットの並びだけを抽出する
    original_parts = original.scan(/[a-zA-Z!?]+/)

    if original_parts.empty?
      return to_kana(str)
    end

    convert_parts = []
    i = 0
    pos = 0
    while pos < str.length
      if original_parts[i].nil?
        convert_parts << str[pos..-1]
        break
      end
      found = str.index(original_parts[i].gsub(/[!?]/, '_').downcase, pos)
      if found.nil?
        convert_parts << str[pos..-1]
        break
      end
      convert_parts << str[pos...found]
      pos = found + original_parts[i].length
      i += 1
    end

    convert_parts = convert_parts.map do |part|
      to_kana(part)
    end

    # convertedの数だけ繰り返す
    result = ''
    for i in 0..convert_parts.length - 1
      result += convert_parts[i] + (original_parts[i] || '')
    end

    convert_parts.each_with_index.map { |part, i| part + (original_parts[i] || '') }.join
  end

  private

  def to_romaji(str, table1, table2, table3)
    # 文字列を正規化
    # -w, -W: UTF-8
    # -h1: 片仮名を平仮名に変換する
    # -Z: X0208 アルファベットといくつかの記号を ASCII に変換する
    str = NKF.nkf('-w -W -h1 -Z', str).downcase

    result = ''
    i = 0
    while i < str.length
      char = str[i]
      has_next_char = i + 1 < str.length
      # 拗音の処理
      if has_next_char && table2.key?(str[i..i+1])
        result += table2[str[i..i+1]]
        i += 2
        next
      end
      # 促音の処理
      if char == 'っ' && has_next_char && table1.key?(str[i + 1])
        result += table1[str[i + 1]][0]
        i += 1
        next
      end
      # 1文字の処理
      if table1.key?(char)
        result += table1[char]
        i += 1
        next
      end
      if table3.key?(char)
        result += table3[char]
        i += 1
        next
      end
      # 英数字だったらそのまま
      if char.match?(/[a-zA-Z0-9]/)
        result += char
        i += 1
        next
      end
      i += 1
    end
    result
  end
end
