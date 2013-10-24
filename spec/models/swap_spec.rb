require 'spec_helper'

describe Swap do

  let(:user) { FactoryGirl.create(:user) }
  before { @swap = user.swaps.build(description: "Ofrezco una buena trabla de surf",
    	offer: "Tabla de Surf", want: "Clases de piano") }

  subject { @swap }

  it { should respond_to(:user_id) }
  it { should respond_to(:description) }
  it { should respond_to(:offer) }
  it { should respond_to(:want) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do 
  	before { @swap.user_id = nil }
  	it { should_not be_valid }
  end

  describe "description" do 

	  describe "is blank" do 
	  	before { @swap.description = " " }
	  	it { should_not be_valid }
	  end

	  describe "is too long" do 
	  	before { @swap.description = "a"*141 }
	  	it { should_not be_valid }
	  end
	end



  describe "with blank offer" do 
  	before { @swap.offer = " " }
  	it { should_not be_valid }
  end

  describe "blank want should be valid" do 
  	before { @swap.want= " " }
  	it { should be_valid }
  end


end