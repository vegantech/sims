def mock_array stubs = {}
  mock_model(Array, stubs)
end

def mock_enrollment stubs = {}
  mock_model(Enrollment, stubs)
end

def mock_flag stubs = {}
  mock_model(Flag, stubs)
end

def mock_student stubs = {}
  mock_model(Student, stubs)
end

def mock_school stubs ={}
  mock_model(School, stubs)
end

def mock_intervention stubs = {}
  mock_model(Intervention,stubs)
end

def mock_district stubs ={}
  mock_model(District, stubs)
end

def mock_objective_definition stubs ={}
  mock_model(ObjectiveDefinition, stubs)
end

def mock_state stubs={}
  mock_model(State,stubs)
end

def mock_country stubs={}
  mock_model(Country,stubs)
end

def mock_user stubs={}
  mock_model(User,stubs)
end

module Spec
  module Mocks
    module Methods
      def stub_association!(association_name, methods_to_be_stubbed = {})
        mock_association = Spec::Mocks::Mock.new(association_name.to_s)
        methods_to_be_stubbed.each do |method, return_value|
          mock_association.stub!(method).and_return(return_value)
        end
        self.stub!(association_name).and_return(mock_association)
      end
    end
  end
end

