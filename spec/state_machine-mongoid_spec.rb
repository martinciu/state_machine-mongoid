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
      @vehicle = Vehicle.create!
    end

    it "should be parked" do
      @vehicle.should be_parked
      @vehicle.state.should == "parked"
    end

    context "after igniting" do

      it "should be ignited" do
        @vehicle.ignite!
        @vehicle.should be_idling
      end
    end
  end

  context "read from database" do
    before(:each) do
      vehicle = Vehicle.create!
      @vehicle = Vehicle.find(vehicle.id)
    end
    it "should has sate" do
      @vehicle.state.should_not be_nil
    end
    it "should state transition" do
      @vehicle.ignite
      @vehicle.should be_idling
    end
  end
end
