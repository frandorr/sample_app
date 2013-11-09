require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }	
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) } #this is for hash encription
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  #Users I follow
  it { should respond_to(:followed_users) }
  #reverse columns so we could implement user.followers with lil' effort
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  #swaps
  it { should respond_to(:swaps) }
  it { should respond_to(:swaps_feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      # toggle flip de admint attribute from false to true
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email=" " }
  	it { should_not be_valid }
  end

  #Check lenght:
   describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  #Check Email is valid:

   describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp 
                                          a+b@baz.cn foo@bar-.com]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end



  #password tests:
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

    describe "remember token" do
      before { @user.save }
      its(:remember_token) { should_not be_blank }
    end 
  end

  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  describe "micropost associations" do
    before { @user.save }
    # This uses the let! (read “let bang”) method in place of let; 
    # the reason is that let variables are lazy, meaning that they 
    # only spring into existence when referenced. 
    # The problem is that we want the microposts to exist immediately, 
    # so that the timestamps are in the right order and so 
    # that @user.microposts isn’t empty. 
    # We accomplish this with let!, which forces the corresponding 
    # variable to come into existence immediately.
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      #to_a = to array
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "when destroy user, should destroy associated microposts" do 
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do 
      let(:unfollowed_post) do 
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do 
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      #Include checks if an array contains the element given
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do 
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do 
    let(:other_user) { FactoryGirl.create(:user) }
    before do 
      @user.save
      #if follow fails raise an exception (!)
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do 
      #we change subject with subject method, changing user with other_user
      subject { other_user }
      its(:followers) { should include(@user) }
    end 

    describe "and unfollowing" do 
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "swaps" do

    describe "swap associations" do 

      before { @user.save }
      let!(:older_swap) do 
        FactoryGirl.create(:swap, user: @user, created_at: 1.day.ago,
                            place: "Buenos Aires")
      end
      let!(:newer_swap) do 
        FactoryGirl.create(:swap, user: @user, created_at: 1.hour.ago,
                            place: "Buenos Aires")
      end

      it "should have the rigth swap in the right order" do 
        expect(@user.swaps.to_a).to eq [newer_swap, older_swap]
      end

      it "should destroy associated swaps" do 
        swaps = @user.swaps.to_a
        @user.destroy
        expect(swaps).not_to be_empty
        swaps.each do |swap|
          expect(Swap.where(id: swap.id)).to be_empty
        end
      end

      describe "status" do
        let(:distant_swap) do
          FactoryGirl.create(:swap, user: FactoryGirl.create(:user), 
                                    place: "Paris")
        end

        let(:near_swap) do 
          FactoryGirl.create(:swap, user: FactoryGirl.create(:user),
                                    place: "Florida, Buenos Aires")
        end

        its(:swaps_feed) do
          Swap.near(@user.ip_address) do |swap|
            should include(swap)
          end
        end
        # its(:swaps_feed) { should include(newer_swap) }
        # its(:swaps_feed) { should include(older_swap) }
        its(:swaps_feed) { should_not include(distant_swap) }
        its(:swaps_feed) { should include(near_swap) }
      end

    end
  end
end
