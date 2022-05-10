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
  end
end  
