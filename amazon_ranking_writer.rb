require 'csv'
require 'nokogiri'
require 'open-uri'
require 'kconv'
class AmazonScrape
  def initialize(url)
    @doc = Nokogiri::HTML(open(url), nil, 'utf-8')
  end

  def number_format(number)
    number.delete!('.')
    number.strip!
  end

  def title_format(title)
    title.strip!
  end

  def price_format(price)
    price.gsub(/[^\d]/, '').to_i
  end
end

class BookRanking < AmazonScrape
  def CsvWrite
    CSV.open('amazon_book_ranking.csv', 'w') do |csv|
      csv << %w[number title author price]
      @doc.xpath("//div[@class='a-fixed-left-grid-col a-col-right']").each do |node|
        number = node.xpath(".//span[@class='zg_rankNumber']").text
        title = node.xpath(".//div[@class='p13n-sc-truncate p13n-sc-line-clamp-2']").text
        author = node.xpath(".//span[@class='a-size-small a-color-base']").text
        # 著者はリンク付きの場合がある
        author = node.xpath(".//a[@class='a-size-small a-link-child']").text if author.empty?
        price = node.xpath(".//span[@class='p13n-sc-price']").text
        csv << [number_format(number),
                title_format(title),
                author,
                price_format(price)]
      end
    end
  end
end

while
    selects = ['1:AmazonBookランキング',
               '1:AmazonBookランキング',
               '1:AmazonBookランキング',
               '0:終了']
    p selects
    print '半角で番号を入力してください：'
    select_number = gets.to_i
    case select_number
    when 1
      url = 'https://www.amazon.co.jp/gp/top-sellers/books/ref=crw_ratp_ts_books'
      url_data = BookRanking.new(url)
      url_data.CsvWrite
      p 'csv書き込み完了！'
      break
    when 0
      break
    end
end
