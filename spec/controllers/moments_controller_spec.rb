require 'rails_helper'

RSpec.describe MomentsController, type: :controller do
  describe "moments#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "moments#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "moments#create action" do
    it "should successfully create a moment in our database" do
      post :create, params: { moment: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      moment = Moment.last
      expect(moment.message).to eq("Hello!")
    end

    it "should properly deal with validation errors" do
      post :create, params: { moment: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Moment.count).to eq 0
    end
  end
end
