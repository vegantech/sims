class GroupedProgressEntry
  class AggregateChart
    NUMBER_OF_STUDENTS_ON_GRAPH=10

    COLORS= [ "FF0000", "00FF00", "0000FF", "FFFF00", "FF00FF", "00FFFF", "000000",
        "800000", "008000", "000080", "808000", "800080", "008080", "808080",
        "C00000", "00C000", "0000C0", "C0C000", "C000C0", "00C0C0", "C0C0C0",
        "400000", "004000", "000040", "404000", "400040", "004040", "404040",
        "200000", "002000", "000020", "202000", "200020", "002020", "202020",
        "600000", "006000", "000060", "606000", "600060", "006060", "606060",
        "A00000", "00A000", "0000A0", "A0A000", "A000A0", "00A0A0", "A0A0A0",
        "E00000", "00E000", "0000E0", "E0E000", "E000E0", "00E0E0", "E0E0E0"  ]


    def initialize(opts ={})
      @probe_definition = opts[:probe_definition]
      @intervention = opts[:intervention]
    end

    def ipa
      @ipa ||=InterventionProbeAssignment.find_all_by_probe_definition_id(
        @probe_definition.id,
        :include => [:probes,{:intervention=>:student}], :conditions => ["probes.score is not null and interventions.intervention_definition_id = ?",
          @intervention.intervention_definition_id])
    end

    def all_students
      @students ||=ipa.collect(&:intervention).collect(&:student).flatten
    end

    def all_probes
      @probes ||=ipa.collect(&:probes)
    end

    def scores
      @scores ||=all_probes.flatten.collect(&:score)
    end

    def dates
      @dates ||= all_probes.flatten.collect(&:administered_at)
    end

    def max_score
      @max_score ||= scores.max
    end

    def min_score
      @min_score ||= [0,scores.min].min || 0
    end

    def max_date
      @mad_date ||= dates.max
    end

    def group_size
      NUMBER_OF_STUDENTS_ON_GRAPH
    end

    def min_date
      @min_date ||= dates.min
    end

    def chart_page(page=0)
      #      probe_scores
      #       scores, grouped by date?

          low=page.to_i*group_size
          high = (low+group_size) -1

          probes=all_probes[low..high]
          students=all_students[low..high]
          chm=[]

          idx=0
          scaled_scores=probes.collect do |probe_groups|
            scaled_dates=[]
            scaled_scores = []
            probe_groups.each do |probe|
              scaled_scores << 100*(probe.score-min_score)/(max_score - min_score + 0.0001)
              scaled_dates << 100 * (probe.administered_at - min_date) / (max_date - min_date + 0.0001)
            end
            if probe_groups.size == 1
              chm << "@o,#{COLORS[idx]},0,#{scaled_dates.first/100}:#{scaled_scores.first/100},4"
            end
            idx = idx+1
            [scaled_dates.join(","),scaled_scores.join(",")].join("|")

          end.join("|")


          students.each_with_index{|s,idx| chm << "o,#{COLORS[idx]},#{idx},,4"}

          #    student_names
          #   probe_defintion
          #  probe_brenchmark




          { 'chdl' => students.collect(&:fullname).join("|"),
            'chco' => COLORS[low..high].join(","),
            'cht' => 'lxy',
            'chs' => '600x500',
            'chxt'=> 'x,y',
            'chxr' => "1,#{min_score},#{max_score}",
          'chxl' => "0:|#{min_date}|#{max_date}",
          'chm' => chm.join("|"),
            'chid' => Time.now.usec,
            'chd' => "t:#{scaled_scores}"}
    end
  end
end
