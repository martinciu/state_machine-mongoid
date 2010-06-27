require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "StateMachineMongoid integration" do
  before(:all) do
    Mongoid.configure do |config|
      name = "state_machine-mongoid"
      host = "localhost"
      config.allow_dynamic_fields = false
      config.master = Mongo::Connection.new.db(name)
    end
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
        @vehicle.idling?.should be_true
      end
    end
    
    
  end

end
