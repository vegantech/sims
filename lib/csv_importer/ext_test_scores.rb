module CSVImporter
  class ExtTestScores < CSVImporter::Base
    FIELD_DESCRIPTIONS = {
        district_student_id: "Key for student",
        name: "Name of exam.   For WKCE it should be WKCE 4 Reading   (WKCE Grade Subject)",
        date: "Date of exam",
        scale_score: "Scaled Score",
        result: "Interpreted result",
        end_date: "Not used"
    }
    class << self
      def description
        'Test Scores for the extended profile. For the WKCE scores will be displayed based on the result: "1-minimal", "2-basic", "3-proficient", "4-advanced" <br />
         For other exams, scores will be displaed as "scalescore / result'
      end

      def csv_headers
        [:district_student_id, :name, :date, :scale_score, :result, :end_date]
      end

      def overwritten
        "All test scores for your students get removed and replaced by what is in the file.   If you use the append_suffix then the removal step is skipped."
      end

      def load_order
      end

      def removed
        "Any scores not in the file.  If the _append is added to the filename, no files are removed"
      end

#      def related
#      end

      def how_often
        "Start of the school year.
        (Note this is a part of the extended profile and not required for functionality of SIMS, so it can be done infrequently.)"
      end

#      def alternate
#      end
      #
      def how_many_rows
        "One row per test per student."
      end

      def upload_responses
        super
      end

      def append_info
        "The append will check a few random records to see if there are any duplicates, if so it will fail.  Note: duplicate test scores are still possible, please
        try to avoid uploading scores with the _append that are already in SIMS."
      end

      def supports_append?
        true
      end

      def append_file_name
        file_name.sub(/.csv$/, "_append.csv")
      end
    end

    private

    def index_options
      [:district_student_id]
    end

    def sims_model
      ExtTestScore
    end

    def migration t
      t.column :district_student_id, :string, limit: Student.columns_hash["district_student_id"].limit, null: Student.columns_hash["district_student_id"].null
      t.column :name, :string
      t.column :date, :date
      t.column :scale_score, :float
      t.column :result, :string
      t.column :end_date, :date
   end

    def temporary_table?
      true
    end

    def delete
      return 0 if @append

      query ="
       delete from ea using  ext_test_scores ea
       inner join students stu on stu.id=ea.student_id and stu.district_id = #{@district.id}
       where
       stu.district_student_id != ''
        "
      ActiveRecord::Base.connection.update query
    end

    def insert
      return 0 if fail_if_matches_and_appending?
      query=("insert into ext_test_scores
      (student_id, name, date, scaleScore, result, enddate, created_at, updated_at)
      select stu.id,
      te.name, te.date, te.scale_score, te.result, te.end_date,
       curdate(), curdate() from #{temporary_table_name} te
      inner join students stu on stu.district_student_id = te.district_student_id
      where stu.district_id = #{@district.id}
      and  stu.district_student_id != ''
      "
      )
      ActiveRecord::Base.connection.update query
    end

    def fail_if_matches_and_appending?
      inner_query = "select s.id, name, date from #{temporary_table_name} tets inner join students s on s.district_student_id = tets.district_student_id
      and s.district_id = #{@district.id}
      limit 10"
      q = "select ets.id from ext_test_scores ets inner join (#{inner_query}) iq on
      iq.id = ets.student_id and iq.name = ets.name and iq.date = ets.date"

      if @append and (ActiveRecord::Base.connection.update(q) > 0)
        @messages << "There were duplicates, remove them or upload all scores without appends"
      end
    end

    def confirm_count?
      return true
    end
  end
end

