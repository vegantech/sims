if ENV['VIEWCOV']
  erb_logger = Logger.new 'tmp/rendered_erb'
  ActiveSupport::Notifications.subscribe "render_template.action_view" do |_name, _start, _finish, _id, payload|
    erb_logger.info payload[:identifier]
  end

  ActiveSupport::Notifications.subscribe "render_partial.action_view" do |_name, _start, _finish, _id, payload|
    erb_logger.info payload[:identifier]
  end
end
