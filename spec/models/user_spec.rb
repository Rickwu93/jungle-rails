require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validation' do
    it "should have matching password for both password areas" do
      @user = User.create({
        name: "Yagami Light",
        email: "light@deathnote.com",
        password: "testing1",
        password_confirmation: "testing2"
      })
      expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
    end

    it "should not create an account unless emails are unique and not case sensitive" do
      @user1 = User.create({
        name: "Yagami Light",
        email: "light@deathnote.com",
        password: "testing1",
        password_confirmation: "testing1"
      })

      @user2 = User.create({
        name: "Yogurt light",
        email: "LIGHT@DEATHNOTE.com",
        password: "testing1",
        password_confirmation: "testing1"
      })
      expect(@user2.errors.full_messages).to include "Email has already been taken"
    end

    it "should require a name during signup" do
      @user = User.create({
        name: nil,
        email: "LIGHT@DEATHNOTE.com",
        password: "testing1",
        password_confirmation: "testing1"
      })
      expect(@user.errors.full_messages).to include "Name can't be blank"
    end

    it "should require a email during signup" do
      @user = User.create({
        name: "Yagami Light",
        email: nil,
        password: "testing1",
        password_confirmation: "testing1"
      })
      expect(@user.errors.full_messages).to include "Email can't be blank"
    end  

    it "require the password length to be more than 5 characters" do
      @user = User.create({
        name: "Yagami Light",
        email: "light@deathnote.com",
        password: "test",
        password_confirmation: "test"
      })
      expect(@user.errors.full_messages).to include "Password is too short (minimum is 5 characters)"
    end
  end
  
  describe '.authenticate_with_credentials' do
    it "should login the user with the valid credentials" do
      User.create!({
        name: "Yagami Light",
        email: "light@deathnote.com",
        password: "testing1",
        password_confirmation: "testing1"
      })
      @user_lookup = User.authenticate_with_credentials("light@deathnote.com", "testing1")
      expect(@user_lookup[:name]).to eq("Yagami Light")
      expect(@user_lookup[:email]).to eq("light@deathnote.com")
    end

    it "should not login with invalid credentials" do
      @bad_user = User.authenticate_with_credentials("invalid@test.com", "12345")
      expect(@bad_user).to be_nil
    end

    it "should login the user even with trailing spaces in the email field" do
      User.create!({
        name: "Misa Amane",
        email: "misa@deathnote.com",
        password: "random1",
        password_confirmation: "random1"
      })
      @spaces_user = User.authenticate_with_credentials("    misa@deathnote.com      ", "random1")
      expect(@spaces_user[:name]).to eq("Misa Amane")
      expect(@spaces_user[:email]).to eq("misa@deathnote.com")
    end  

    it "should log the user in even if their email is case sensitive" do
      User.create!({
        name: "Misa Amane",
        email: "Misa@deathnote.com",
        password: "random1",
        password_confirmation: "random1"
      })
      @spaces_user = User.authenticate_with_credentials("MIsA@dEatHnOte.com", "random1")
      expect(@spaces_user[:name]).to eq("Misa Amane")
      expect(@spaces_user[:email]).to eq("Misa@deathnote.com")
    end  
  end
end
