require 'spec_helper'

describe "Static pages" do

  subject { page }

  #To avoid repetition among tests we could use shared_examples
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Calo Social' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do 
      let(:user) { FactoryGirl.create(:user) }
      before do 
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum" )
        FactoryGirl.create(:micropost, user: user, content: "Dolor sie amet")
        FactoryGirl.create(:swap, user: user, description: "Holi")
        FactoryGirl.create(:swap, user: user, description: "Chau")
        sign_in user
        visit root_path
      end

      it "renders the user's feed" do 
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it "renders the user's swaps feed" do 
        user.swaps_feed("24.232.154.67").each do |item|
          expect(page).to have_selector("li#swap#{item.id}", 
                                text: item.description)
        end
      end
      describe "follower/following counts" do 
        let(:other_user) { FactoryGirl.create(:user) }
        before do 
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end


  describe "Help page" do
    before { visit help_path }

    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"

  end

  describe "About page" do
    before { visit about_path }

    let(:heading) { 'About' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"  
  end

  describe "Signup page" do
    before { visit new_user_path }
    let(:heading) { 'Sign up' }
    let(:page_title) { 'Sign up' }

    it_should_behave_like "all static pages"
  end



  #Test links route to correct url:
  it "has the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "calo social"
    expect(page).to have_title(full_title(''))
  end
end
