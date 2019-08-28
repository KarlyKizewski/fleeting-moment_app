require 'rails_helper'

RSpec.describe MomentsController, type: :controller do
  describe "moments#show action" do
    it "shoud successfully show the page if the moment is found" do
      moment = FactoryBot.create(:moment)
      get :show, params: { id: moment.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the moment is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end


  describe "moments#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "moments#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "moments#create action" do

    it "should require users to be logged in" do
      post :create, params: { moment: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a moment in our database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { moment: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      moment = Moment.last
      expect(moment.message).to eq("Hello!")
      expect(moment.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { moment: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Moment.count).to eq 0
    end
  end
end
