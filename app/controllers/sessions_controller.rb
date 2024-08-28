class SessionsController < ActionController::API

  def create
    email = params[:email]
    code = params[:code]

    verify(code, email)
  end

  def authorization
    email = params[:email]
    user = reset_pin(email)

    AuthMailer.send_code(user.last_pin, email).deliver_now!

    render json: {"message": "E-mail sent!"}
  end

  def reset_pin(email)
    user = User.find_by("email": email)
    user.update_attributes(:last_pin => rand(1000..9999), :pin_sent_at => Time.now)
    user.save
    if user
      user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def clean_pin(email)
    user = User.first.unset(:last_pin)
    if user
      user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def verify(pin, email)
    user = User.find_by("email": email)
    
    if Time.now > user.pin_sent_at.advance(minutes: 30)
      render json: { error: 'Your verification code has expired!' }, status: :unauthorized
    elsif user.last_pin.to_i  == pin.to_i 
      clean_pin(email)
      session[:user_id] = user.id
      render json: {"message": "successfully logged in"}, status: :ok
    else
      render json: { error: 'Verification code invalid.' }, status: :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    head :no_content
  end

end