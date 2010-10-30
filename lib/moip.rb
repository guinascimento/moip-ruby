require "rubygems"
require 'httparty'
require "nokogiri"

require "direct_payment"

module PayMaster

  class MoIP
    include HTTParty

    CONFIG = YAML.load_file("config.yaml")["development"]
    STATUS = { 1 => "authorized", 2 => "started", 3 => "printed", 4 => "completed", 5 => "canceled", 6 => "analysing"}

    base_uri "#{CONFIG["uri"]}/ws/alpha"
    basic_auth CONFIG["token"], CONFIG["key"]

    class << self

      # Envia uma instrução para pagamento único
      def checkout(attributes = {})
        full_data = post('EnviarInstrucao/Unica', :body => DirectPayment.direct(attributes))

        raise(StandardError, "Ocorreu um erro ao chamar o webservice") if full_data.nil?

        response = full_data["ns1:EnviarInstrucaoUnicaResponse"]["Resposta"]
        raise(StandardError, response["Erro"]) if response["Status"] == "Falha"

        return response
      end

      # Consulta dos dados das autorizações e pagamentos associados à Instrução
      def query(token)
        full_data = get("ConsultarInstrucao/#{token}")
        raise(StandardError, "Ocorreu um erro ao chamar o webservice") if full_data.nil?

        response = full_data["ns1:ConsultarTokenResponse"]["RespostaConsultar"]
        raise(StandardError, response["Erro"]) if response["Status"] == "Falha"

        return response
      end

      # Retorna a URL de acesso ao MoIP
      def moip_page(token)
        raise(StandardError, "É necessário informar um token para retornar os dados da transação") if token.nil?
        "#{CONFIG["uri"]}/Instrucao.do?token=#{token}"
      end

      # Monta o NASP
      def notification(params)
        notification = {}
        notification[:transaction_id] = params["id_transacao"]
        notification[:amount]         = sprintf("%.2f", params["valor"].to_f / 100).to_d
        notification[:status]         = STATUS[params["status_pagamento"].to_i]
        notification[:code]           = params["cod_moip"]
        notification[:payment_type]   = params["tipo_pagamento"]
        notification[:email]          = params["email_consumidor"]
        notification
      end

    end

  end

end