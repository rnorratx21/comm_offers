module ActivityConceptList
  attr_accessor :activity_concept_list

  
  private
  def update_activity_concepts
    self.role_activity_concepts.destroy_all
    unless activity_concept_list.nil?
      activity_concept_list.each do |k,v|
        v.each do |a,b|
          rac = RoleActivityConcept.new
          rac.role = self
          rac.concept = Concept.find(k)
          rac.activity = Activity.find(a)
          rac.save
        end  
      end
    end
  end

end
