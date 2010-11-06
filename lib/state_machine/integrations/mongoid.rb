module StateMachine
  module Integrations #:nodoc:
    module Mongoid
      include ActiveModel
      
      # The default options to use for state machines using this integration
      @defaults = {:action => :save, :use_transactions => false}
      
      # Should this integration be used for state machines in the given class?
      # Classes that include Mongoid::Document will automatically use
      # the Mongoid integration.
      def self.matches?(klass)
        defined?(::Mongoid::Document) && klass <= ::Mongoid::Document
      end
      
      protected
        # Never add observer support
        def supports_observers?
          false
        end
        
        # Always adds validation support
        def supports_validations?
          true
        end
        
        # Only runs validations on the action if using <tt>:save</tt>
        def runs_validations_on_action?
          action == :save
        end
        
        # Only adds dirty tracking support if ActiveRecord supports it
        def supports_dirty_tracking?(object)
          defined?(::Mongoid::Dirty) && object.respond_to?("#{attribute}_changed?") || super
        end
        
        # Always uses the <tt>:mongoid</tt> translation scope
        def i18n_scope
          :mongoid
        end
        
        # Only allows translation of I18n is available
        def translate(klass, key, value)
          if defined?(I18n)
            super
          else
            value ? value.to_s.humanize.downcase : 'nil'
          end
        end
        
        # Defines an initialization hook into the owner class for setting the
        # initial state of the machine *before* any attributes are set on the
        # object
        def define_state_initializer
          @instance_helper_module.class_eval <<-end_eval, __FILE__, __LINE__
            # Ensure that the attributes setter gets used to force initialization
            # of the state machines
            def initialize(attributes = nil, *args)
              attributes ||= {}
              super
            end
            
            # Hooks in to attribute initialization to set the states *prior*
            # to the attributes being set
            def attributes=(new_attributes, *args)
              if new_record? && !@initialized_state_machines
                @initialized_state_machines = true
                
                ignore = if new_attributes
                  attributes = new_attributes.dup
                  attributes.stringify_keys!
                  sanitize_for_mass_assignment(attributes).keys
                else
                  []
                end
                
                initialize_state_machines(:dynamic => false, :ignore => ignore)
                super
                initialize_state_machines(:dynamic => true, :ignore => ignore)
              else
                super
              end
            end
          end_eval
        end
        
        # Adds support for defining the attribute predicate, while providing
        # compatibility with the default predicate which determines whether
        # *anything* is set for the attribute's value
        def define_state_predicate
          name = self.name
          
          # Still use class_eval here instance of define_instance_method since
          # we need to be able to call +super+
          @instance_helper_module.class_eval do
            define_method("#{name}?") do |*args|
              args.empty? ? super(*args) : self.class.state_machine(name).states.matches?(self, *args)
            end
          end
        end
        
    end
  end
end
