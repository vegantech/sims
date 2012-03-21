class Groups::AssignmentsController < ApplicationController
  before_filter :find_group

  private
  def find_group
    @group = current_school.groups.find(params[:group_id])
  end

end


