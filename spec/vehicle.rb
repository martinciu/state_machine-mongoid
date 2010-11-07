class Vehicle
  include Mongoid::Document

  field :state, :type => String, :default => "parked"
  field :alarm_state, :type => Integer, :default => 1

  state_machine :state, :initial => :parked do
    before_transition :parked => any - :parked, :do => :put_on_seatbelt

    after_transition :on => :crash, :do => :tow
    after_transition :on => :repair, :do => :fix
    after_transition any => :parked do |vehicle, transition|
      vehicle.seatbelt_on = false
    end

    event :park do
      transition [:idling, :first_gear] => :parked
    end

    event :ignite do
      transition :stalled => same, :parked => :idling
    end

    event :idle do
      transition :first_gear => :idling
    end

    event :shift_up do
      transition :idling => :first_gear, :first_gear => :second_gear, :second_gear => :third_gear
    end

    event :shift_down do
      transition :third_gear => :second_gear, :second_gear => :first_gear
    end

    event :crash do
      transition all - [:parked, :stalled] => :stalled, :unless => :auto_shop_busy?
    end

    event :repair do
      # The first transition that matches the state and passes its conditions
      # will be used
      transition :stalled => :parked, :if => :auto_shop_busy?
      transition :stalled => same
    end

    state :parked do
      def speed
        0
      end
    end

    state :idling, :first_gear do
      def speed
        10
      end
    end

    state :second_gear do
      def speed
        20
      end
    end
  end

  state_machine :alarm_state, :initial => :active, :namespace => 'alarm' do
    event :enable do
      transition all => :active
    end

    event :disable do
      transition all => :off
    end

    state :active, :value => 1
    state :off, :value => 0
  end

  def initialize(*args)
    @seatbelt_on = false
    @time_used = 0
    super() # NOTE: This *must* be called, otherwise states won't get initialized
  end

  def put_on_seatbelt
    @seatbelt_on = true
  end

  def auto_shop_busy?
    false
  end

  def tow
    # tow the vehicle
  end

  def fix
    # get the vehicle fixed by a mechanic
  end
end
