def scrape_news(arg)
  #ライブラリ読み込み
  require 'open-uri' # URLアクセス用ライブラリ
  require 'nokogiri' # Nokogiriライブラリ
  
  # スクレイピング先のURL
  base_url = 'https://news.yahoo.co.jp/'
  link_url = 'https://news.yahoo.co.jp/topics/top-picks'
  
  #変数定義
  charset = nil
  title_ary = Array.new
  link_ary = Array.new
  hash = Hash.new
  
  #最終ページまで繰り返しニュースを取得する
  while link_url != "#{base_url}"
  
    #htmlを読み込む
    html = URI.open(link_url).read
    doc = Nokogiri::HTML.parse(html, nil, charset)
    
    #ニュースタイトル一覧
    i = 0
    while true
      title = doc.css('.newsFeed_item_title')[i]
        if title.nil?
          break
        end
      title_ary.push(title.text.strip)
      i += 1
    end
    
    #ニュースリンク一覧
    doc.css('.newsFeed_item_link').each do |link|
      link_ary.push(link[:href]) 
    end
    
    #カウントして表示件数を計算
    if title_ary.size != link_ary.size
      puts 'The numbers of titles and links do not match'
      break
    end
    
    #ハッシュにタイトルとリンクを格納
    count = title_ary.size - 1
    for c in 0 .. count
      hash[title_ary[c]] = link_ary[c]
    end
    
    #次ページへのリンク
    element = doc.at_xpath('//a[text()="次へ"]')
    if element.nil?
      break
    end
    href = element.attributes["href"].value
    #次ページの絶対URLを生成
    link_url = "#{base_url}#{href}"
    
    # アクセス間隔を0.1秒空ける
    sleep 0.1 
  end
  
  #検索ボックスに入力がない場合は全量、ある場合は該当ニュースを表示する
  if arg.nil?
    return hash
  else
    return hash.select {|k,v| k.include?(arg)}
  end
end