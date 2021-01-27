# frozen_string_literal: true

# ControlChecklistExcelExport
#
class Parser
  prepend SimpleCommand

  def initialize(url)
    url = url
  end

  def call
    parse
  end

  private

  attr_reader :url

  def parse
    debugger
  end

end
