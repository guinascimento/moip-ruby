require "moip"

pagador = { :nome => "Luiz Inácio Lula da Silva",
            :login_moip => "guinascimento",
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

boleto = { :valor => "50",
           :id_proprio => "Pag#{rand(1000)}",
           :forma => "BoletoBancario",
           :dias_expiracao => 2,
           :pagador => pagador }

debito = { :valor => "8.90",
           :id_proprio => "Pag#{rand(1000)}",
           :forma => "DebitoBancario",
           :instituicao => "Itau"
         }

response = MoIP.checkout(boleto)
puts MoIP.moip_page(response["Token"])

           
#debito = { :valor => "8.90", :id_proprio => "Pag#{rand(1000)}", :forma => "DebitoBancario", :instituicao => "Itau" }
#credito = { :valor => "22.90", :id_proprio => "Pag#{rand(1000)}", :forma => "CartaoCredito", :instituicao => "Visa", :numero => "345678901234564", :expiracao => "08/11", :codigo_seguranca => "1234", :nome => "Luiz Inácio Lula da Silva", :identidade => "111.111.111-11", :telefone => "(61)9999-9999", :data_nascimento => "25/10/1980", :parcelas => "2", :recebimento => "AVista" }

#puts QPag::MoIP.query("T2X0Q1N021E0B2S9U1P0V3Y0G1F570Y2P4M0P000M0Z0F0J0G0U4N6C7W5T9").inspect