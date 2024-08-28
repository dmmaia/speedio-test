
class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index, :update]
  before_action :authorize_user, only: [:update]

  def index
    user = User.find(current_user._id)
    render json: user, except: [:last_pin, :pin_sent_at]
  end

  def find_by_email(email)
    @user = User.find_by("email": email)
    render json: @user
  end

  def destroy
    @user .destroy!
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, except: [:last_pin, :pin_sent_at],status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(current_user.email)
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def webhook

    render json: {message: params[:status]}, 
      status: :bad_request unless params[:status] == "CREATION_SUCCESS"

    verify = verify_account(params[:account_id])

    user = User.find(params[:name])

    if verify['type']=="LINKEDIN"
      user.update!(unipile_linkedin_account_id:params[:account_id])
    else
      user.update!(unipile_email_account_id:params[:account_id])
    end

    render json:{message: "handle sucessful!"}
  end

  def show_connect_link
    generated_link = create_connection_link()

    render json:{connection_link: generated_link['url']}
  end

  private

    def set_webhook
      params.permit(:status, :account_id, :name)
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end

    def authorize_user
      unless @user._id == current_user._id
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end

    def create_connection_link
      url = URI.parse("https://"+ENV['UNIPILE_URL']+"/api/v1/hosted/accounts/link")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      
      request = Net::HTTP::Post.new(url)
      request["accept"] = 'application/json'
      request["content-type"] = 'application/json'
      request["X-API-KEY"] = ENV['UNIPILE_API_KEY']
      request.body = "{\"type\":\"create\",\"providers\":[\"LINKEDIN\",\"MAIL\",\"GOOGLE\",\"OUTLOOK\"],\"api_url\":\"https://"+ENV['UNIPILE_URL']+"\",\"expiresOn\":\"2025-12-31T23:59:59.999Z\",\"name\":\""+current_user._id+"\"}"
                     
      response = http.request(request)
      JSON.parse(response.body)
    end

    def verify_account(id)
      url = URI.parse("https://"+ENV['UNIPILE_URL']+"/api/v1/accounts/"+id)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["accept"] = 'application/json'
      request["X-API-KEY"] = ENV['UNIPILE_API_KEY']

      response = http.request(request)
      JSON.parse(response.body)
    end
end
