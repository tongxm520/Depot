require 'openssl'
require 'base64'

message = %(1. 服务器空间（m0~m8）)
key = "yourpass"
#encrypt_key = Digest::SHA1.hexdigest("yourpass")
encrypt_key = key

cipher = OpenSSL::Cipher::Cipher.new("des-cbc")
cipher.encrypt # Call this before setting key or iv
cipher.key = encrypt_key
#iv = cipher.iv = cipher.random_iv
ciphertext = cipher.update(message)
ciphertext << cipher.final
puts "Encrypted \"#{message}\" with \"#{key}\" to:\n\"#{ciphertext.force_encoding("UTF-8")}\"\n"
puts "--------------------------------------------------------"


# Base64-encode the ciphertext
encodedCipherText = Base64.encode64(ciphertext)
puts "After Base64 encodedCipherText is : #{encodedCipherText}"
puts "--------------------------------------------------------"

# Base64-decode the ciphertext and decrypt it
decodedCipherText = Base64.decode64(encodedCipherText)
puts "After Base64 decodedCipherText is : #{decodedCipherText}"
puts "--------------------------------------------------------"



cipher = OpenSSL::Cipher::Cipher.new("des-cbc")
cipher.decrypt
cipher.key = encrypt_key
#cipher.iv = iv
plaintext = cipher.update(decodedCipherText)
plaintext << cipher.final

# Print decrypted plaintext; should match original message
puts plaintext.class
puts "Decrypted: \"#{plaintext}\""



