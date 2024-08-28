require 'httparty'

class ApplicationController < ActionController::API
  
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  private

    def authenticate_user
      render json: { error: 'Not Authorized' }, status: :unauthorized unless current_user
    end
end
