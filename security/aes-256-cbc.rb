require 'openssl'
require 'digest/sha1'
c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
c.encrypt
# yourpass is what is used to encrypt/decrypt
c.key = key = Digest::SHA1.hexdigest("yourpass")
puts "key: #{key}"
c.iv = iv = c.random_iv
e = c.update("计算机技术")
e << c.final
puts "encrypted: #{e.inspect}\n"

c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
c.decrypt
c.key = key
c.iv = iv
d = c.update(e)
d << c.final
puts "decrypted: #{d}\n"


