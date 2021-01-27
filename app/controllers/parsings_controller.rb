class ParsingsController < ApplicationController

  def parse_catalog
    file = Parser.call("https://ssnab.ru/product/").result
  end

  def parse_products
    ProductParser.call("https://ssnab.ru/product/").result
  end
  def index
    @products = Product.all
  end

  def export_excel
    file = ExportProducts.call(Product.all).result
    send_data file.to_stream.read, type: 'application/xlsx', filename: "products.xlsx"
  end
end
