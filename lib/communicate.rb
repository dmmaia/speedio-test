module Communicate
  
  def self.send_mail(company_id, text_body, current_user)
    return {message: "E-mail não encontrado, por favor vincule uma conta válida"} unless current_user.unipile_email_account_id
    
    company = Company.find(company_id)

    body = {
      'account_id'=> current_user.unipile_email_account_id,
      'body'=> text_body,
      "to"=>JSON.generate([{"display_name": company.name,"identifier": company[:decisor][:email]}])
    }

    create_request("/api/v1/emails", body)

    JSON.parse(@response.body)
  end

  def self.send_linkedin_message(company_id, text_body)
    return {message: "Conta Linkedin não encontrada, por favor vincule uma conta válida"} unless current_user.unipile_email_account_id
   
    get_user_perfil(company_id)
    return user_perfil.errors unless @user_perfil.code == 200

    body = {
      'account_id'=> current_user.unipile_email_account_id,
      'text'=> text_body,
      "attendees_ids"=> JSON.parse(@user_perfil.body)["provider_id"]
    }

    create_request("/api/v1/chats", body)

    JSON.parse(@response.body)
  end

  def self.send_linkedin_connection(company_id, text_body)
    return {message: "Conta Linkedin não encontrada, por favor vincule uma conta válida"} unless current_user.unipile_linkedin_account_id

    get_user_perfil(company_id)
    return { message: "Erro ao buscar perfil"}unless @user_perfil.code == 200

    response = HTTParty.post(
      "https://"+ENV['UNIPILE_URL']+"/api/v1/users/invite",
      body: "{\"account_id\":\""+current_user.unipile_linkedin_account_id+"\",\"provider_id\":\""+JSON.parse(@user_perfil.body)["provider_id"]+"\",\"message\":\""+text_body+"\"}",
      headers: { 'Content-Type' => 'application/json', "X-API-KEY" => ENV['UNIPILE_API_KEY'] },
    )

    JSON.parse(response.body)
  end

  private
    def self.create_request(url, body)
      @response = HTTParty.post(
        "https://"+ENV['UNIPILE_URL']+url,
        body: body,
        headers: { 'Content-Type' => 'multipart/form-data', "X-API-KEY" => ENV['UNIPILE_API_KEY'] },
        multipart: true 
      )
    end

    def self.get_user_perfil(company_id)
      company = Company.find(company_id)
      user_public_identificator = company[:decisor][:linkedin_url].sub!('https://', '').sub!('www.linkedin.com/in/', '')

      @user_perfil = HTTParty.get(
          "https://"+ENV['UNIPILE_URL']+"/api/v1/users/"+user_public_identificator+"?notify=true&account_id="+current_user.unipile_linkedin_account_id+"",
          headers: { 'Content-Type' => 'application/json', "X-API-KEY" => ENV['UNIPILE_API_KEY'] },
        )
    end
end