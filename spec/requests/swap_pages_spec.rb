require 'spec_helper'

describe "Swap pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }



  describe "swap creation" do
    before { visit swaps_path }

    describe "with invalid information" do

      it "should not create a swap" do
        expect { click_button "Create" }.not_to change(Swap, :count)
      end

      describe "error messages" do
        before { click_button "Create" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'swap_description', with: "Swap Description"
      				 fill_in 'swap_offer', with: "What I offer" 
							 fill_in 'swap_want', with: "What I want" }

      it "should create a swap" do
        expect { click_button "Create" }.to change(Swap, :count).by(1)
      end
    end
  end
end
