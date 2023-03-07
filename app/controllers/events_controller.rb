class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  after_action :verify_authorized, except: :index

  def index
    @events = Event.all
  end

  def show
    @new_comment = @event.comments.build(params[:comment])
    @new_subscription = @event.subscriptions.build(params[:subscription])
    @new_photo = @event.photos.build(params[:photo])

    begin
      authorize @event
    rescue Pundit::NotAuthorizedError
      if @event.pincode.present?
        flash.now[:alert] =
          I18n.t('pundit.wrong_pincode') if params[:pincode].present?

        render 'password_form'
      end
    end
  end

  def new
    @event = current_user.events.build

    authorize @event
  end

  def edit
    authorize @event
  end

  def create
    @event = current_user.events.build(event_params)

    authorize @event

    if @event.save
      redirect_to @event, notice: I18n.t('controllers.events.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @event

    if @event.update(event_params)
      redirect_to @event, notice: I18n.t('controllers.events.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event

    @event.destroy

    redirect_to root_path, notice: I18n.t('controllers.events.destroyed')
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).
      permit(:title, :description, :address, :datetime, :pincode)
  end
end
