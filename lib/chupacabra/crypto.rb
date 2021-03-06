require 'openssl'
require 'base64'

module Chupacabra
  module Crypto

    class WrongPassword < StandardError; end

    extend self
    PASSWORD_LENGTH = 32

    def encrypt(text, password)
      encrypter = OpenSSL::Cipher::Cipher.new 'AES256'
      encrypter.encrypt
      encrypter.pkcs5_keyivgen password
      Base64.encode64(encrypter.update(text) + encrypter.final).strip
    end

    def decrypt(text, password)
      encrypted = Base64.decode64(text).strip
      decrypter = OpenSSL::Cipher::Cipher.new 'AES256'
      decrypter.decrypt
      decrypter.pkcs5_keyivgen password
      decrypter.update(encrypted) + decrypter.final

    rescue OpenSSL::Cipher::CipherError
      raise WrongPassword, 'Wrong password'
    end

    def generate_password
      letters = 'abcdefghijklmnopqrstuwxyz'
      upcase = letters.upcase
      numbers = '1234567890'
      stuff = '!@$%^&#()-_'
      all = [letters, upcase, numbers, stuff].collect{ |collection| collection.split('') }
      output = all.collect { |collection| collection.shuffle.first }
      (PASSWORD_LENGTH - all.length).times { output << all.flatten.shuffle.first }
      output.join
    end
  end
end
