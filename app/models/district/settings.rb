module District::Settings
  SETTINGS = [:key, :previous_key, :google_apps_domain, :custom_interventions ]
  BOOLEAN_SETTINGS = [:restrict_free_lunch, :forgot_password, :lock_tier, :google_apps, :email_on_team_consultation_response, :show_team_consultations_if_pending]
  BOOLEAN_SETTINGS <<  :windows_live  if defined? ::WINDOWS_LIVE_CONFIG
  SETTINGS.push(*BOOLEAN_SETTINGS)
  extend ActiveSupport::Concern

  included do
    begin
      after_initialize :default_settings_to_hash
      #raise "Remove this block" if Rails.version > "3.2"
      serialize :settings, Hash
      SETTINGS.each do |s|
        define_method("#{s}=") do |value|
          self.settings ||= {}
          @old_key = settings[:key] if s==:key

          self.settings[s] = value
          self.settings_will_change!
        end

        define_method(s) {(settings || Hash.new)[s]}
        define_method("#{s}?") {!!send(s)}
      end

    end

    public
    BOOLEAN_SETTINGS.each do |setting|
      define_method("#{setting}?") {self.settings[setting].present? && self.settings[setting] != "0"}
    end
  end

  private
    def default_settings_to_hash
      self[:settings] ||= {}
      self[:settings][:restrict_free_lunch] = true unless self.settings.keys.include?(:restrict_free_lunch)
    end
end

