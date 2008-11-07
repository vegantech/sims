class RailmailController < ApplicationController
  layout 'railmail'
  
  if Railmail::ActionMailer::InstanceMethods.railmail_settings[:before_filter]
    Railmail::ActionMailer::InstanceMethods.railmail_settings[:before_filter].each do |sym|
      before_filter sym
    end
  end
  
  def index    
    @deliveries = RailmailDelivery.paginate :page => params[:page], :order => 'sent_at DESC', :per_page => 30
    
    #@delivery_window = @delivery_pages.current.window 4
    #logger.debug  @delivery_window.pages.length
    #@delivery_window = @delivery_pages.current.window(4 + (9 - @delivery_window.pages.length)) if @delivery_window.pages.length < 9
    #fill_date_ranges
  end
  
  def read
    @delivery = RailmailDelivery.find params[:id]
    @delivery.read_at = Time.now
    @delivery.save!
  end
  
  def raw
    @delivery = RailmailDelivery.find params[:id]
    render :text => @delivery.raw.to_s, :content_type => 'text/plain'
  end
  
  def part
    @delivery = RailmailDelivery.find params[:id]
    @raw = @delivery.raw
    @mime = params[:part]
    
    @part = @raw.parts.select {|p| p.content_type == @mime }.first
    render :text => @part.body.to_s, :content_type => @mime
  end
  
  def resend
    @delivery = RailmailDelivery.find params[:id]
    
    to = params[:to].split(',') unless params[:to].blank?
    @delivery.resend to
  end
  
  private
  def fill_date_ranges
    @date_ranges = {}
    @delivery_window.pages.each do |page|
      first = RailmailDelivery.find :first, :order => 'sent_at DESC',                           
                                            :limit  =>  1,
                                            :offset =>  page.offset
      return if first.nil?
      
      last = RailmailDelivery.find :first, :order => 'sent_at DESC',                           
                                            :limit  =>  1,
                                            :offset =>  page.last_item - 1
                                            
      
      @date_ranges[page.number] = [first.sent_at, last.sent_at]                                     
    end
  end
end

RailmailController.append_view_path(File.join( File.dirname(__FILE__),'..','views'))