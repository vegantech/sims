class PrimeCache
  extend FlagsHelper
  extend ActionView::Helpers::AssetTagHelper
  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::TagHelper
  extend ActionView::Helpers::TextHelper

  def self.config
    ApplicationController.new.instance_variable_get("@_config")
  end

  def self.flags
    pids = `ps w |grep -v grep |grep 'runner PrimeCache'| cut -f 1 -d' '`
    if pids.size > 1
      puts "Script already running"
      exit 0
    end

    ctrl = ApplicationController.new
    hit=0
    miss=0
    last_ran_key= ctrl.fragment_cache_key("prime_cache_last_ran")
    last_ran = ctrl.read_fragment(last_ran_key) || 10.years.ago
    this_run = Time.now



    Student.find_each(:include=>[:team_consultations_pending, :flags,:ignore_flags,:custom_flags, {:interventions=>:user}],
                                                            :conditions =>  ["students.updated_at > ?",last_ran])  do |student|
      key = ctrl.fragment_cache_key  ["status_display",student]
      if Rails.cache.exist?(key)
       hit+=1
      else
        miss+=1
        Rails.cache.write key, ctrl.view_context.status_display(student)
      end
    end
    ctrl.write_fragment(last_ran_key,this_run)

    puts "hits: #{hit}   misses:#{miss}"

  end

end
