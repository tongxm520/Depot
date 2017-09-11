require 'digest'
require 'openssl'
require 'base64'

ALG = "DES-EDE3-CBC"
cipher = OpenSSL::Cipher::Cipher.new(ALG)
cipher.encrypt
key = cipher.random_key
iv = cipher.random_iv
cipher.key = key
cipher.iv = iv
data = "中国人民万岁！"
result = cipher.update(data)
result << cipher.final
File.open("enc.txt", "wb"){|f| f.write result}

hex_key = key.unpack("H*")[0]
hex_iv=iv.unpack("H*")[0]

puts "hex_key = #{hex_key}"
puts "hex_iv = #{hex_iv}"
