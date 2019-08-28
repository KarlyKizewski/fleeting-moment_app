class MomentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @moment = Moment.new
  end

  def index
  end

  def create
    @moment = current_user.moments.create(moment_params)
    if @moment.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @moment = Moment.find_by_id(params[:id])
    if @moment.blank?
      render plain: 'Not Found', status: :not_found
    end
  end

  private

  def moment_params
    params.require(:moment).permit(:message)
  end
end
