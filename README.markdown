# MoIP

Esta Gem permite utilizar a API do MoIP, gateway de pagamentos do IG

## Instalação

$ gem install moip

## Utilização

Crie os dados do pagador

pagador = { :nome => "Luiz Inácio Lula da Silva",
            :login_moip => "lula",
            :email => "presidente@planalto.gov.br",
            :tel_cel => "(61)9999-9999",
            :apelido => "Lula",
            :identidade => "111.111.111-11",
            :logradouro => "Praça dos Três Poderes",
            :numero => "0",
            :complemento => "Palácio do Planalto",
            :bairro => "Zona Cívico-Administrativa",
            :cidade => "Brasília",
            :estado => "DF",
            :pais => "BRA",
            :cep => "70100-000",
            :tel_fixo => "(61)3211-1221" }

Dados do boleto

boleto = { :valor => "50",
		   :id_proprio => "Pag#{rand(1000)}",
	       :forma => "BoletoBancario",
	       :dias_expiracao => 5,
	       :pagador => pagador }

Faça o checkout

	MoIP.checkout(boleto)