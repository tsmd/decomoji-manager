require 'test_helper'

class RomajiKanaConverterTest < Minitest::Test
  include RomajiKanaConverter
  
  def test_to_hepburn_romaji
    assert_equal 'konnnichiha', to_hepburn_romaji('こんにちは')
    assert_equal 'arigatai_', to_hepburn_romaji('ありがたい！')
    assert_equal 'se-fu_', to_hepburn_romaji('セーフ！')
    assert_equal 'uiux', to_hepburn_romaji('ＵＩＵＸ')
    assert_equal 'fizzbuzz', to_hepburn_romaji('Fizz Buzz')
    assert_equal 'axtsu', to_hepburn_romaji('あっ')
    assert_equal 'axtsuaxtsu', to_hepburn_romaji('あっあっ')
    assert_equal 'ahhai', to_hepburn_romaji('あっはい')
    assert_equal 'maggyo', to_hepburn_romaji('まっぎょ')
    assert_equal 'giruthi', to_hepburn_romaji('ギルティ')
    assert_equal 'yazawaganannteiukana', to_hepburn_romaji('YAZAWAがなんていうかな')
    assert_equal '13jishussha', to_hepburn_romaji('13じしゅっしゃ')
    assert_equal 'ds_store', to_hepburn_romaji('.DS_Store')
  end

  def test_to_kunrei_romaji
    assert_equal 'konnnitiha', to_kunrei_romaji('こんにちは')
    assert_equal 'se-hu_', to_kunrei_romaji('セーフ！')
    assert_equal 'altu', to_kunrei_romaji('あっ')
    assert_equal 'altualtu', to_kunrei_romaji('あっあっ')
    assert_equal 'ahhai', to_kunrei_romaji('あっはい')
    assert_equal 'giruthi', to_kunrei_romaji('ギルティ')
    assert_equal '13zisyussya', to_kunrei_romaji('13じしゅっしゃ')
  end

  def test_to_kana
    assert_equal 'こんにちは', to_kana('konnnichiha')
    assert_equal 'こんにちは', to_kana('konnnitiha')
    assert_equal 'せんやいちや', to_kana('sennyaitiya')
    assert_equal 'ありがたい_', to_kana('arigatai_')
    assert_equal 'せーふ_', to_kana('se-hu_')
    assert_equal 'ういうx', to_kana('uiux')
    assert_equal 'ふぃっzぶっz', to_kana('fizzbuzz')
    assert_equal 'あっ', to_kana('altu')
    assert_equal 'あっあっ', to_kana('axtsuaxtsu')
    assert_equal 'あっはい', to_kana('ahhai')
    assert_equal 'ぎるてぃ', to_kana('giruthi')
    assert_equal '13じしゅっしゃ', to_kana('13zisyussya')
  end
  
  def test_to_kana_adjusted
    assert_equal 'こんにちは', to_kana_adjusted('konnnichiha', '今日は')
    assert_equal 'こんにちは!', to_kana_adjusted('konnnichiha_', '今日は！')
    assert_equal 'UIUX', to_kana_adjusted('uiux', 'ＵＩＵＸ')
    assert_equal 'FizzBuzz', to_kana_adjusted('fizzbuzz', 'Fizz Buzz')
    assert_equal 'さんじのおやつはぶんめいどう', to_kana_adjusted('sanzinooyatsuhabunmeidou', '三時のおやつは文明堂')
    assert_equal 'GENKIもりもりMAXです', to_kana_adjusted('genkimorimorimaxdesu', 'GENKI盛り盛りMAXです')
    assert_equal 'いきはYOIYOIかえりはKOWAI', to_kana_adjusted('ikihayoiyoikaerihakowai', '行きはYOIYOI帰りはKOWAI')
    assert_equal 'うかつあり', to_kana_adjusted('ukatuari', '迂闊あり')
  end
end
