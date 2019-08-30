class MomentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @moment = Moment.new
  end

  def index
  end

  def show
    @moment = Moment.find_by_id(params[:id])
    return render_not_found if @moment.blank? 
  end

  def edit
    @moment = Moment.find_by_id(params[:id])
    return render_not_found if @moment.blank? 
    return render_not_found(:forbidden) if @moment.user != current_user
  end

  def create
    @moment = current_user.moments.create(moment_params)
    if @moment.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @moment = Moment.find_by_id(params[:id])
    return render_not_found if @moment.blank?
    return render_not_found(:forbidden) if @moment.user != current_user
    @moment.update_attributes(moment_params)
    if @moment.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @moment = Moment.find_by_id(params[:id])
    return render_not_found if @moment.blank?
    return render_not_found(:forbidden) if @moment.user != current_user
    @moment.destroy
    redirect_to root_path
  end

  private

  def moment_params
    params.require(:moment).permit(:message)
  end

  def render_not_found
    render plain: 'Not found', status: :not_found
  end

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end
end
