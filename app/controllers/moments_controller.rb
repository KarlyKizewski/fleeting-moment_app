class MomentsController < ApplicationController
  
  def new
    @moment = Moment.new
  end

  def index
  end

  def create
    @moment = Moment.create(moment_params)
    redirect_to root_path
  end

  private

  def moment_params
    params.require(:moment).permit(:message)
  end
end
