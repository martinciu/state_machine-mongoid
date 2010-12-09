require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "StateMachineMongoid integration" do
  before(:all) do
    Mongoid.configure do |config|
      name = "state_machine-mongoid"
      host = "localhost"
      config.allow_dynamic_fields = false
      config.master = Mongo::Connection.new.db(name)
    end
    Mongoid.master.collections.select{ |c| c.name !~ /system\./ }.each { |c| c.drop }
  end

  context "new vehicle" do
    before(:each) do
      @vehicle = Vehicle.new
    end

    it "should be parked" do
      @vehicle.parked?.should be_true
      @vehicle.state.should == "parked"
    end

    context "after igniting" do
      before(:each) do
        @vehicle.ignite
      end

      it "should be ignited" do
        @vehicle.state.should == "idling"
        @vehicle.idling?.should be_true
      end
      
      it "should add error messages when transition is invalid" do
        @vehicle.ignite.should be_false
        @vehicle.errors.should_not be_empty
      end
      
      it "should not allow to set incorrect state" do
        @vehicle.state = "flying"
        @vehicle.valid?.should be_false
      end
      
    end
  end

  context "read from database" do
    before(:each) do
      @vehicle = Vehicle.find(Vehicle.create.id)
    end
    it "should has sate" do
      @vehicle.state.should_not nil
    end
    it "should state transition" do
      @vehicle.ignite
      @vehicle.idling?.should be_true
    end
    
    it "should add error messages when transition is invalid" do
      @vehicle.ignite.should be_true
      @vehicle.ignite.should be_false
      @vehicle.errors.should_not be_empty
   end
    
  end
end
