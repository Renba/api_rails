require 'spec_helper'

describe Api::V1::ProductsController do

  describe "GET #SHOW" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response[:product]
      expect(product_response[:title]).to eql @product.title
    end

    it "has the user as a embeded object" do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eql @product.user.email
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do

    context "when is not receiving any product_ids parameter" do
      before(:each) do
        4.times { FactoryGirl.create :product }
        get :index
      end

      it "returns 4 records from the database" do
        products_response = json_response[:products]
        expect(products_response).to have(4).items
      end

      it "returns the user object into each product" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      it_behaves_like "paginated list"

      it { should respond_with 200 }
    end

    context "when product_ids parameter is sent" do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times { FactoryGirl.create :product, user: @user }
        get :index, product_ids: @user.product_ids
      end

      it "return just the products that belong to the user" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql @user.email
        end
      end
    end

  end

  describe "POST #create" do

    context "when is successfuly created do" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it "renders the json representation for the product record just created" do
        products_response = json_response[:product]
        expect(products_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: 'TV', price: '20 pesos'}
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it "renders and error json" do
        products_response = json_response
        expect(products_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        products_response = json_response
        expect(products_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }

    end
  end

  describe "PUTS #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfuly updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id,
                         product: { title: 'tv 3D'} }
      end

      it "render the json representation for the updated user" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eql 'tv 3D'
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id,
                         product: { price: 'tv 3D'}}
      end

      it "renders an error json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it " renders the json errors on whye the user couldn't be updated" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }

    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @product.id }
    end

    it { should respond_with 204 }
  end

end
