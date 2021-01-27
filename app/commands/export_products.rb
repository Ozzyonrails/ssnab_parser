# frozen_string_literal: true

# ControlChecklistExcelExport
#
class ExportProducts
  prepend SimpleCommand

  def initialize(products)
    @products = products
  end

  def call
    build_table
  end

  private

  attr_reader :products

  def build_table
    file = Axlsx::Package.new
    workbook = file.workbook
    add_worksheet(workbook)
    file
  end

  def add_worksheet(workbook)
    workbook.add_worksheet(name: 'products') do |sheet|
      workbook.styles do |style|
        wrap_text = add_style(style)
        center_merged = add_center_style(style)
        add_data(sheet, wrap_text, center_merged)
        sheet.column_widths 50, 10, 40, 15
      end
    end
  end

  def add_data(sheet, wrap_text, center_merged)
    sheet.add_row %w[Код Группа Название Описание Ссылка], style: wrap_text

    products.each do |product|

      add_row(sheet, wrap_text, product)
    end
  end

  def add_center_style(style)
    style.add_style b: true,
                    sz: 12,
                    border: { style: :thin, color: '00' },
                    height: 140,
                    alignment: { horizontal: :center,
                                 vertical: :center,
                                 wrap_text: true }
  end

  def add_style(style)
    style.add_style sz: 12,
                    border: { style: :thin, color: '00' },
                    height: 140,
                    alignment: { horizontal: :left,
                                 vertical: :center,
                                 wrap_text: true }
  end

  def add_row(sheet, wrap_text, product)
        sheet.add_row [product.code, product.main_category, product.title, product.description, product.link],
                  style: wrap_text
  end

end
