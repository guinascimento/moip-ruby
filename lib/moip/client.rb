# encoding: utf-8
require 'httparty'

module MoIP
  class WebServerResponseError < StandardError ; end
  class MissingConfigError < StandardError ; end
  class MissingTokenError < StandardError ; end
  class MissingKeyError < StandardError ; end

  class Client
    include HTTParty

    base_uri "#{MoIP.uri}/ws/alpha"
    basic_auth MoIP.token, MoIP.key

    class << self

      # Verifica conta
      # URL Produção: https://www.moip.com.br/ws/alpha/VerificarConta/{login_moip}
      # URL SandBox: https://desenvolvedor.moip.com.br/sandbox/ws/alpha/VerificarConta/{login_moip}
      # XML de Resposta:
      # <ns1:verificarContaResponse>
      #     <RespostaVerificarConta>
      #         <Status>{status da conta}</Status>
      #     </RespostaVerificarConta>
      # </ns1:verificarContaResponse>
      # 
      # Valores Esperados: {status da conta}
      # Inexistente " Login inexistente no sistema MoIP "
      # Criado  " Login criado, porem não verificado "
      # Verificado  " Login verificado "
# MoIP::Client.verify 'aaa'

      def verify account
        full_data = peform_action!(:get, "VerificarConta/#{account}")
        return full_data["ns1:verificarContaResponse"]["RespostaVerificarConta"]["Status"] == "Verificado"
      end

      # Envia uma instrução para pagamento único
      def checkout(attributes = {})
        body = DirectPayment.body(attributes)
        puts "************ XML ************"
        puts body
        full_data = peform_action!(:post, 'EnviarInstrucao/Unica', :body => body)
       # raise full_data.inspect
        get_response!(full_data["ns1:EnviarInstrucaoUnicaResponse"]["Resposta"])
      end

      # Consulta dos dados das autorizações e pagamentos associados à Instrução
      def query(token)
        full_data = peform_action!(:get, "ConsultarInstrucao/#{token}")

        get_response!(full_data["ns1:ConsultarTokenResponse"]["RespostaConsultar"])
      end

      # Retorna a URL de acesso ao MoIP
      def moip_page(token)
        raise(MissingTokenError, "É necessário informar um token para retornar os dados da transação") if token.nil?
        "#{MoIP.uri}/Instrucao.do?token=#{token}"
      end

      # Monta o NASP
      def notification(params)
        notification = {}
        notification[:transaction_id] = params["id_transacao"]
        notification[:amount]         = params["valor"]
        notification[:status]         = MoIP::STATUS[params["status_pagamento"].to_i]
        notification[:code]           = params["cod_moip"]
        notification[:payment_type]   = params["tipo_pagamento"]
        notification[:email]          = params["email_consumidor"]
        notification
      end

      private

      def peform_action!(action_name, url, options = {})

        raise(MissingConfigError, "É necessário criar um arquivo de configuração para o moip. Veja mais em: https://github.com/moiplabs/moip-ruby") if MoIP.token.nil? && MoIP.key.nil?

        raise(MissingTokenError, "É necessário informar um token na configuração") if MoIP.token.nil? || MoIP.token.empty?

        raise(MissingKeyError, "É necessário informar um key na configuração") if MoIP.key.nil? || MoIP.key.empty?
        
        response = self.send(action_name, url, options)
        raise(WebServerResponseError, "Ocorreu um erro ao chamar o webservice") if response.nil?
        response
      end

      def get_response!(data)
        # raise data.inspect
        err = data["Erro"].is_a?(Array) ? data["Erro"].join(", ") : data["Erro"]
        raise(WebServerResponseError, err) if data["Status"] == "Falha"
        data
      end
    end
  end
end
