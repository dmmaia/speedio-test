# README
* Ruby version 3.3.0

#Principais Rotas#

* User

POST /users
```sh
{
    "name": string,
	"email": string,
}
```

POST /authorization
```sh
Envia código de login OTP para email
{
    "email": string
}
```

POST /authenticate
```sh
Validação do codio e login
{
    "email": string,
    "code": integer
}
```

GET /users-generate-link
```sh
Gera link para conectar contas de Email e Linkedin
```

GET /users-webhook
```sh
webhook usado quando uma conta é conectada com o link unipile
Link passado no arquivo .env
```

* Company

POST /companies
```sh
{
    "name":string
	"decisor": {
		"email": string,
		"linkedin_url": string
	},
	"cnpj": string
}
```

* Automations

POST /automations
```sh
{
    "company_id":string,
	"tipo": linkedin_connection|linkedin_message|email,
	"message": string,
	"programmed_to": Date
}
```

----

whenever usado para automação

* variaveis de ambiente
*DATABASE_URI=
*MONGOID_ENV=
*MAILER_ADDRESS=
*MAILER_PORT=
*UNIPILE_URL=
*UNIPILE_API_KEY=
*WEB_HOOK=
