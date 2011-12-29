module Spec
  module Rails
    module Mocks
      def method_missing(method,*args,&blk)
        method_name = method.to_s.split('_',2)
        if method_name.first == 'mock' and defined?(method_name.last.camelize)
          class_name = method_name.last
          mock_model(class_name.camelize.constantize,*args)
        else
          super(method,*args,&blk)
        end
      end
    end
  end

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
