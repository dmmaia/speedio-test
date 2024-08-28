class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show update destroy ]
  before_action :authorize_user, only: [:show, :update]

  # GET /companies
  def index
    @companies = Company.where("user_id": current_user._id)
    render json: @companies
  end

  def show
    render json: @company
  end

  # POST /companies
  def create
    @company = Company.new({
      **company_params, 
      :user_id => current_user._id,
    })

    if @company.save
      render json: @company, status: :created, location: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_params
      {**params.require(:company).permit(:user_id, :cnpj, :name),
        "decisor": {
          "email": params[:decisor][:email],
          "linkedin_url": params[:decisor][:linkedin_url]
        }
      }
    end

    def authorize_user
      unless BSON::ObjectId.from_string(@company.user_id) == current_user._id
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
end
