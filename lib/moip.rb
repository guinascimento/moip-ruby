# encoding: utf-8
require "rubygems"
require 'active_support/core_ext/module/attribute_accessors'

module MoIP
  autoload :DirectPayment, 'moip/direct_payment'
  autoload :Client,        'moip/client'

  # URI para acessar o serviço
  mattr_accessor :uri
  @@uri = 'https://www.moip.com.br'

  # Token de autenticação
  mattr_accessor :token

  # Chave de acesso ao serviço
  mattr_accessor :key

  def self.setup
    yield self
  end

  STATUS = {1 => "authorized", 2 => "started", 3 => "printed", 4 => "completed", 5 => "canceled", 6 => "analysing"}
end
