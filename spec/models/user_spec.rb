require 'rails_helper'

RSpec.describe User, :type => :model do
  user =
    described_class.new(id: 0,
                        first_name: "John",
                        last_name: "Doe",
                        major: "CSCE",
                        email: "john@tamu.edu",
                        password: "abcdef")

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is valid with a spartan email" do
      user.email = "john@spartan-tutoring.com"
      expect(user).to be_valid
    end

    it "is valid without a major" do
      user.major = nil
      expect(user).to be_valid
    end

    it "is not valid without a first name" do
      user.first_name = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a last name" do
      user.last_name = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with a short password' do
      user.password = "abc"
      expect(user).to_not be_valid
      user.password = "abcdef"
    end

    it "is not valid with a bad email" do
      user.email = "something@something.com"
      expect(user).to_not be_valid
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user).to_not be_valid
    end
  end
end
