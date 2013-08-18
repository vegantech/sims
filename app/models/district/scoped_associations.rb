module District::ScopedAssociations
  def recommendation_definitions
    RecommendationDefinition.scoped
  end

  def recommendation_answer_definitions
    RecommendationAnswerDefinition.joins(:recommendation_definition)
  end

  def frequencies
    Frequency.scoped
  end

  def time_lengths
    TimeLength.scoped
  end

  def news_items
    news
  end

  def method_missing(method_name,*args,&block)
    if klass=get_class_for_method_missing(method_name) and joins=district_joins(klass)
      klass.joins(joins).where("districts.id" => self.id)
    else
      super
    end
  end

  def get_class_for_method_missing(method_name)
    return(method_name.to_s.classify.constantize) rescue NameError
  end

  def district_joins(klass)
    if klass.const_defined?("DISTRICT_PARENT")
      return joins_from_reflection(klass.reflect_on_association(klass.const_get("DISTRICT_PARENT")))
    end
    klass.reflect_on_all_associations(:belongs_to).tap do |bels|
      if bels.length == 1
        return joins_from_reflection(*bels)
      end
    end
    nil
  end

  private

  def joins_from_reflection(bel_ref)
    if bel_ref.name == :district
      return :district
    else
      return {bel_ref.name => district_joins(bel_ref.klass)}
    end
  end

end
