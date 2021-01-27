# frozen_string_literal: true

# ControlChecklistExcelExport
#
class ControlChecklistExcelExport
  prepend SimpleCommand

  def initialize(answer_list)
    @answer_list = answer_list
  end

  def call
    build_table
  end

  private

  attr_reader :answer_list

  def build_table
    file = Axlsx::Package.new
    workbook = file.workbook
    add_worksheet(workbook)
    file
  end

  def add_worksheet(workbook)
    workbook.add_worksheet(name: 'Checklist') do |sheet|
      workbook.styles do |style|
        wrap_text = add_style(style)
        center_merged = add_center_style(style)
        add_data(sheet, wrap_text, center_merged)
        sheet.column_widths 50, 10, 40, 15
      end
    end
  end

  def add_data(sheet, wrap_text, center_merged)
    sheet.add_row %w[QUESTION ANSWER COMMENTS REFERENCE], style: wrap_text
    questions = "#{answer_list.code}Checklist".constantize.questions
    @previous_group_header = ''
    @current_row = 1
    questions.each do |question|
      @new_header = question.question_group
      unless @new_header.nil? || (@new_header == @previous_group_header)
        add_group_header(@new_header, sheet, center_merged)
      end
      add_row(sheet, wrap_text, question)
      @current_row += 1
      @previous_group_header = @new_header
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

  def add_row(sheet, wrap_text, question)
    answer = answer(question)

    sheet.add_row [question.body,
                   answer&.answer_body.to_s,
                   answer&.comment.to_s,
                   question.ref],
                  height: calculate_height(question.body),
                  style: wrap_text
  end

  def calculate_height(question)
    (question.length / 57.0).ceil * 17
  end

  def answer(question)
    Answer.find_by(answer_list: answer_list, question_id: question.code)
  end

  def add_group_header(header, sheet, center_merged)
    @current_row += 1
    sheet.merge_cells "A#{@current_row}:D#{@current_row}"
    sheet.add_row [header, '', '', ''], style: [center_merged, center_merged, center_merged, center_merged]
  end
end
