class CicoController < ApplicationController
  skip_before_filter :authenticate, :authorize, :verify_authenticity_token
  #this is just to demo the check in checkout form and will be stripped out eventually

  def index
    if params[:id]
      @cico_setting = current_school.cico_settings.find(params[:id])
      @ipas=@cico_setting.intervention_probe_assignments(current_user)
      @students = @ipas.collect(&:student)
      @expectation_values = @cico_setting.expectation_values.collect{|e| [e,e]}

    else
      @students = CicoTest::STUDENTS
      @expectation_values = CicoTest::EXPECTATIONSTATUS.collect{|e| [e,e]}
    end
  end
  
end


