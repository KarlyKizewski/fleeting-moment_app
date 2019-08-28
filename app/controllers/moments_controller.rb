class MomentsController < ApplicationController
  
  def new
    @moment = Moment.new
  end

  def index
  end

  def create
    @moment = Moment.create(moment_params)
    if @moment.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def moment_params
    params.require(:moment).permit(:message)
  end
end
