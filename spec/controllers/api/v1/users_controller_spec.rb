require 'spec_helper'

describe Api::V1::UsersController do
  
  describe "GET#show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfuly created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201}
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: '12345678',
                                     password_confirmaiton: '12345678'}
        post :create, { user: @invalid_user_attributes}, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it {should respond_with 422}
    end
  end

  describe "PUT/PATCH #update" do
    context "when is successfuly updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, {id: @user.id,
                        user:{ email: "newemail@example.com"} }, format: :json
      end

      it "render the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "newemail@example.com"
      end

      it {should respond_with 200}
    end

    context "when is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
                        user:{ email: "badcorreo" } }, format: :json
      end

      it "render and errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it{ should respond_with 422 }
    end
  end

  describe "when user destroy " do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id}, format: :json
    end

    it{ should respond_with 204 }

  end

end
