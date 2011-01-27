class ExtendedLogger
  def initialize(app)
    @app = app
  end

   EXTENDED_LOG_USER_IDS_PATH = Rails.root.join('public', 'system', 'extended_log_user_ids')
   EXTENDED_LOG_USER_IDS = EXTENDED_LOG_USER_IDS_PATH.exist? ? File.read(EXTENDED_LOG_USER_IDS_PATH).strip.split(",") : []
   EXTENDED_LOG_DIR = Rails.root.join('log', 'extended')
   Dir.mkdir(EXTENDED_LOG_DIR) unless EXTENDED_LOG_DIR.directory?
  def call(env)
    dup._call(env)
  end

  def _call(env)
    user_id = env["rack.session"][:user_id].to_s
    log(user_id, env.inspect) if EXTENDED_LOG_USER_IDS.include?(user_id)
    @status, @headers, @response = @app.call(env)
    log(user_id, @status.inspect) if EXTENDED_LOG_USER_IDS.include?(user_id)
    log(user_id, @headers.inspect) if EXTENDED_LOG_USER_IDS.include?(user_id)
    [@status, @headers, self]
  end

  def each(&block)
    @response.each(&block)
  end

  def log(user_id,to_log)
    File.open(EXTENDED_LOG_DIR.join(user_id.to_s), 'a') do |file|
      file.puts(Time.now)
      file.puts(to_log)
    end
  end
end
