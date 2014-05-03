class District::LogsController < ApplicationController
  def index
    @logs = current_district.logs.for_display(params)
  end
end
