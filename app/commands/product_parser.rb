# frozen_string_literal: true

# ControlChecklistExcelExport
#
class Parser
  prepend SimpleCommand

  def initialize(initial_url)
    @initial_url = initial_url
    @catalog = {}
  end

  def call
    parse
  end

  private

  attr_reader :initial_url

  def parse
    debugger
    # result=HTTParty.get(url)
    parsed_data = get_url(initial_url)
    read_first_level(parsed_data)
    read_second_level
    create_products_to_database
  end

  def create_products_to_database
    @catalog.each do |category, data|
      data['products'].each do |product|
        Product.create(title:product['title'], link:product['link'], main_category:category)

      end
    end
  end

  def read_first_level(data)
    item_divs=data.css("div.container").css("div.item")
    item_divs.each do |div|
      @catalog[div.css("img")[0].attributes['title'].value] = { "link"=> div.css("a")[0].attributes['href'].value, "products" =>[]}
    end
  end

  def read_second_level
    base_url = "https://ssnab.ru"
    @catalog.each do |category, data|
      response_data=get_url("#{base_url}#{data['link']}?PAGEN_1=1")
      begin
         total_pages=response_data.css('ul.pagination').css('li')[-2].css('a').children.to_s.to_i
      rescue
        next
      end

      parse_products_from_all_pages(total_pages,category,base_url, data)
      # response_data.css('div.catalog').css('div.item').each do |product|
      #   tmp_product={}
      #   tmp_product['title'] = product.css('a').css('span')[0].children[0].to_s
      #   tmp_product['link'] = product.css('a')[0].attributes['href'].value
      #   @catalog[category]['products'] << tmp_product
      # end
    end
  end

  def parse_products_from_all_pages(total_pages,category,base_url, data)
    (1..total_pages).to_a.each do |page_number|
      response_data=get_url("#{base_url}#{data['link']}?PAGEN_1=#{page_number}")

      response_data.css('div.catalog').css('div.item').each do |product|
        tmp_product={}
        tmp_product['title'] = product.css('a').css('span')[0].children[0].to_s
        tmp_product['link'] = product.css('a')[0].attributes['href'].value
        @catalog[category]['products'] << tmp_product
      end
    end
  end

  def get_url(url)
    result=HTTParty.get(url)
    Nokogiri::HTML.parse(result)
  end

end
#@catalog.first[1]['products'][0]