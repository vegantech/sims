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
    ctrl = ApplicationController.new
    hit=0
    miss=0
    last_ran_key= ctrl.fragment_cache_key("prime_cache_last_ran")
    last_ran = ctrl.read_fragment(last_ran_key) || 10.years.ago
    this_run = Time.now




    Student.find_each(:include=>[:team_consultations_pending, :flags,:ignore_flags,:custom_flags, {:interventions=>:user}],
                                                            :conditions =>  ["students.updated_at > ?",last_ran])  do |student|
      key = ctrl.fragment_cache_key  ["status_display",student]
      if ctrl.fragment_exist? ["status_display",student]
       hit+=1
      else
        miss+=1
        puts key
        ctrl.write_fragment ["status_display",student],'poop'# ctrl.view_context.status_display(student)
      end
    end
    ctrl.write_fragment(last_ran_key,this_run)

    puts "hits: #{hit}   misses:#{miss}"

  end

end
