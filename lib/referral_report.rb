# encoding: utf-8

require 'csv'
class ReferralReport
  def initialize(district)
    @district = district
  end

  def self.csv(district)
    new(district).referral_report
  end

  def current_district
    @district
  end

  def referral_report
    csv_string = ''
    CSV.generate(csv_string,:row_sep=>"\r\n") do |csv|
      csv << ["personID","referral_request","main_concerns","interventions_tried","family_involvement","external_factors","date","schoolyear"]
      dates_of_sims_data.each do |student|
        if student["id"]
          ufanswers = ActiveRecord::Base.connection.select_rows("select position, ra.text from recommendation_answers ra inner join recommendation_answer_definitions rad on ra.recommendation_answer_definition_id = rad.id  and ra.recommendation_id where ra.recommendation_id = #{student["id"]}").flatten
          answers=ufanswers.collect do |f|
            if f.respond_to?("integer?")
              f
            else
              f=f.tr("’","'")
              f=f.tr("”",'"')
              f=f.tr("“",'"')
              f.gsub! /"/m, "''"
              f
            end
          end
          answers = Hash[*answers]
          csv <<[student["district_student_id"],"Y",answers[1],answers[2],answers[3],answers[4], student["created_at"].to_datetime.strftime("%m/%d/%Y"),nil]
        else
          csv << [student["district_student_id"],"N",nil,nil,nil,nil,nil,student["schoolyear"]] unless student["district_student_id"].blank?
        end
      end
    end
    csv_string
  end

  protected

  def dates_of_sims_data


    referrals= Student.connection.select_all("select distinct s.district_student_id,r.id, r.created_at, (year(r.updated_at + INTERVAL 6 month))  as schoolyear
    from students s inner join recommendations r on r.student_id = s.id and r.promoted=true and r.recommendation=5
    where s.district_id = #{current_district.id}")

    students =Student.connection.select_all(

    "
    select s.district_student_id,  (year(sc.updated_at + INTERVAL 6 month))  as schoolyear from student_comments sc
    inner join students s on sc.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(sc.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from recommendations r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from interventions r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from checklists r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from flags r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id} and r.type = 'CustomFlag'
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from principal_overrides r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from consultation_form_requests r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from consultation_forms r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))
    ")

    students.reject! do |e|
      referrals.any? do |r|
        r["district_student_id"] == e["district_student_id"] &&
          r["schoolyear"] == e["schoolyear"]
      end
    end


    referrals + students
  end



end
