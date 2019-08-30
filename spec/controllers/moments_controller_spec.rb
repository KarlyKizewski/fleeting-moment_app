require 'rails_helper'

RSpec.describe MomentsController, type: :controller do

  describe "moments#destroy action" do
    it "shouldn't allow users who didn't create the moment to destroy it" do
      moment = FactoryBot.create(:moment)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: moment.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a moment" do
      moment = FactoryBot.create(:moment)
      delete :destroy, params: { id: moment.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy moments" do
      moment = FactoryBot.create(:moment)
      sign_in moment.user
      delete :destroy, params: { id: moment.id }
      expect(response).to redirect_to root_path
      moment = Moment.find_by_id(moment.id)
      expect(moment).to eq nil
    end

    it "should return a 404 message if we cannot find a moment with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "moments#update action" do
    it "shouldn't let users who didn't create the moment update it" do
      moment = FactoryBot.create(:moment)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: moment.id, moment: { message: 'wahoo' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a moment" do
      moment = FactoryBot.create(:moment)
      patch :update, params: { id: moment.id, moment: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update moments" do
      moment = FactoryBot.create(:moment, message: "Initial Value")
      sign_in moment.user
      patch :update, params: { id: moment.id, moment: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      moment.reload
      expect(moment.message).to eq "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: 'YOLOSWAG', moment: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      moment = FactoryBot.create(:moment, message: "Initial Value")
      sign_in moment.user
      patch :update, params: { id: moment.id, moment: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      moment.reload
      expect(moment.message).to eq "Initial Value"
    end
  end

  describe "moments#edit action" do
    it "shouldn't let a user who did not create the moment edit a moment" do
      moment = FactoryBot.create(:moment)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: moment.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a moment" do
      moment = FactoryBot.create(:moment)
      get :edit, params: { id: moment.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesfully show the edit form if the moment is found" do
      moment = FactoryBot.create(:moment)
      sign_in moment.user
      get :edit, params: { id: moment.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the moment is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end
  end

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
