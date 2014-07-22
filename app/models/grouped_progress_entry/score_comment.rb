class GroupedProgressEntry
  class ScoreComment
    attr_accessor :date,:score,:comment,:intervention,:id,:numerator,:denominator
    delegate :end, to: :intervention

    def initialize(intervention,user)
      @intervention = intervention
      @id = intervention.id
      @user = user
      @comment = ''
      @errors =''
      @probe = nil
      @score = nil
    end

    def errors
      @errors.to_s
    end

    def update_attributes(params)
      @comment = params['comment']
      @intervention.comment_author=@user.id
      @intervention.comments_attributes = {"0" => {comment: @comment}}
      begin
        @date = Date.civil(params["date(1i)"].to_i,params["date(2i)"].to_i,params["date(3i)"].to_i)
      rescue ArgumentError
        @errors +='Invalid Date'
      end
      @score = params[:score]

      @probe=@intervention.intervention_probe_assignment.probes.build(score: @score, administered_at: @date) unless @score.blank?
    end

    def valid?
      if @intervention.valid? && (!@probe || @probe.valid?)  && @errors.blank?
        true
      else
        @errors += @intervention.errors.full_messages.join(", ") +' ' + @probe.errors.full_messages.join(", ")
        false
      end
    end

    def save
      @intervention.save!
      @probe.save! unless @probe.blank?
    end

    def student
      @intervention.student
    end

    def to_param
      @id
    end
  end
end

