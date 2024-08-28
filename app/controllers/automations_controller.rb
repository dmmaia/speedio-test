class AutomationsController < ApplicationController
  before_action :set_automation, only: %i[ show update destroy ]
  before_action :authorize_user, only: [:show, :update, :destroy]

  # GET /automations
  def index
    @automations = Automation.all

    render json: @automations
  end

  # GET /automations/1
  def show
    #communicate(params[:id])
    render json: @automation
  end

  def communicate(id)
    automation = Automation.find(id)

    case automation.tipo
    when "email"
      Communicate.send_mail(automation.company_id, automation.message, current_user)
    when "linkedin_message"
      Communicate.send_linkedin_message(automation.company_id, automation.message)
    when "linkedin_connection"
      Communicate.send_linkedin_connection(automation.company_id, automation.message)
    end

    automation.update(sent_at:Time.now)

  end

  # POST /automations
  def create
    @automation = Automation.new(automation_params)

    if @automation.save
      render json: @automation, status: :created, location: @automation
    else
      render json: @automation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /automations/1
  def update
    if @automation.update(automation_params)
      render json: @automation
    else
      render json: @automation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /automations/1
  def destroy
    @automation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_automation
      @automation = Automation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def automation_params
      params.require(:automation).permit(:company_id, :tipo, :message, :programmed_to, :sent_at, :Date)
    end

    def authorize_user
      company = Company.find(@automation.company_id)
      unless BSON::ObjectId.from_string(company.user_id )== current_user._id
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
end
