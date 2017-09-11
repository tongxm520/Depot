require 'openssl'
require 'base64'
require 'iconv'

ENCODED_KEY="s56dZN+kAY+KwshANAeAlA6P5f5FNCp5"

def des3_decrypt(assert)
  key = Base64.decode64(ENCODED_KEY)
  des = OpenSSL::Cipher::Cipher.new("des-ede3")
  des.decrypt
  des.key = key
  #puts "output:#{[assert].pack("H*").bytes}"
  result = des.update([assert].pack("H*"))
  result << des.final
  #puts "result:#{result}"
  arr=Iconv.iconv('utf-8', 'gbk', result)
  result=arr[0]
  pattern= /^[a-zA-Z0-9\+\/]+([a-zA-Z0-9\+\/]{1}[a-zA-Z0-9\+\/=]{1}|==)$/
  #Base64编码的正则匹配
  if arr[0]=~ pattern
    result=Base64.decode64(arr[0])
  end
  result
end


puts des3_decrypt("D80C0E48F1262F7AB9AC1D207C929206")
puts des3_decrypt("D80C0E48F1262F7AD79C17D98487FB27")
puts des3_decrypt("42C09E6DC5BBD0EF560F1860E54AD522C664612AAD1EEF2D")
puts des3_decrypt("AE86424DA886538A7D928D8209C056B3C6E080584318D60F")
puts des3_decrypt("532F60E309D7243DC6E080584318D60F")
#puts des3_decrypt("3C45DBAB4BE57D581F0E08704A574F262C7E0ACDBC26D2C9")


puts Base64.encode64("any carnal pleasure.")
puts Base64.encode64("any carnal pleasure")
puts Base64.encode64("any carnal pleasur")
puts Base64.encode64("any carnal pleasu")
puts Base64.encode64("any carnal pleas")

#java加密  ruby解密
#SEED值：idesseedche 

#参考： 

#原文:今天天气很好 
#加密:D80C0E48F1262F7AB9AC1D207C929206 
#解密:今天天气很好 


#原文:今天天气不错 
#加密:D80C0E48F1262F7AD79C17D98487FB27 
#解密:今天天气不错 

#原文:其实今天是在下大雨 
#加密:42C09E6DC5BBD0EF560F1860E54AD522C664612AAD1EEF2D 
#解密:其实今天是在下大雨 


#密文:3C45DBAB4BE57D581F0E08704A574F262C7E0ACDBC26D2C9

#密文:AE86424DA886538A7D928D8209C056B3C6E080584318D60F 
#解密:helloworld

#密文:532F60E309D7243DC6E080584318D60F 
#解密:hello 


#OpenSSL::Cipher.ciphers
#=> ["AES-128-CBC", "AES-128-CFB", "AES-128-CFB1", "AES-128-CFB8", "AES-128-CTR", "AES-128-ECB", "AES-128-OFB", "AES-128-XTS", "AES-192-CBC", "AES-192-CFB", "AES-192-CFB1", "AES-192-CFB8", "AES-192-CTR", "AES-192-ECB", "AES-192-OFB", "AES-256-CBC", "AES-256-CFB", "AES-256-CFB1", "AES-256-CFB8", "AES-256-CTR", "AES-256-ECB", "AES-256-OFB", "AES-256-XTS", "AES128", "AES192", "AES256", "BF", "BF-CBC", "BF-CFB", "BF-ECB", "BF-OFB", "CAMELLIA-128-CBC", "CAMELLIA-128-CFB", "CAMELLIA-128-CFB1", "CAMELLIA-128-CFB8", "CAMELLIA-128-ECB", "CAMELLIA-128-OFB", "CAMELLIA-192-CBC", "CAMELLIA-192-CFB", "CAMELLIA-192-CFB1", "CAMELLIA-192-CFB8", "CAMELLIA-192-ECB", "CAMELLIA-192-OFB", "CAMELLIA-256-CBC", "CAMELLIA-256-CFB", "CAMELLIA-256-CFB1", "CAMELLIA-256-CFB8", "CAMELLIA-256-ECB", "CAMELLIA-256-OFB", "CAMELLIA128", "CAMELLIA192", "CAMELLIA256", "CAST", "CAST-cbc", "CAST5-CBC", "CAST5-CFB", "CAST5-ECB", "CAST5-OFB", "DES", "DES-CBC", "DES-CFB", "DES-CFB1", "DES-CFB8", "DES-ECB", "DES-EDE", "DES-EDE-CBC", "DES-EDE-CFB", "DES-EDE-OFB", "DES-EDE3", "DES-EDE3-CBC", "DES-EDE3-CFB", "DES-EDE3-CFB1", "DES-EDE3-CFB8", "DES-EDE3-OFB", "DES-OFB", "DES3", "DESX", "DESX-CBC", "RC2", "RC2-40-CBC", "RC2-64-CBC", "RC2-CBC", "RC2-CFB", "RC2-ECB", "RC2-OFB", "RC4", "RC4-40", "RC4-HMAC-MD5", "SEED", "SEED-CBC", "SEED-CFB", "SEED-ECB", "SEED-OFB", "aes-128-cbc", "aes-128-cfb", "aes-128-cfb1", "aes-128-cfb8", "aes-128-ctr", "aes-128-ecb", "aes-128-gcm", "aes-128-ofb", "aes-128-xts", "aes-192-cbc", "aes-192-cfb", "aes-192-cfb1", "aes-192-cfb8", "aes-192-ctr", "aes-192-ecb", "aes-192-gcm", "aes-192-ofb", "aes-256-cbc", "aes-256-cfb", "aes-256-cfb1", "aes-256-cfb8", "aes-256-ctr", "aes-256-ecb", "aes-256-gcm", "aes-256-ofb", "aes-256-xts", "aes128", "aes192", "aes256", "bf", "bf-cbc", "bf-cfb", "bf-ecb", "bf-ofb", "blowfish", "camellia-128-cbc", "camellia-128-cfb", "camellia-128-cfb1", "camellia-128-cfb8", "camellia-128-ecb", "camellia-128-ofb", "camellia-192-cbc", "camellia-192-cfb", "camellia-192-cfb1", "camellia-192-cfb8", "camellia-192-ecb", "camellia-192-ofb", "camellia-256-cbc", "camellia-256-cfb", "camellia-256-cfb1", "camellia-256-cfb8", "camellia-256-ecb", "camellia-256-ofb", "camellia128", "camellia192", "camellia256", "cast", "cast-cbc", "cast5-cbc", "cast5-cfb", "cast5-ecb", "cast5-ofb", "des", "des-cbc", "des-cfb", "des-cfb1", "des-cfb8", "des-ecb", "des-ede", "des-ede-cbc", "des-ede-cfb", "des-ede-ofb", "des-ede3", "des-ede3-cbc", "des-ede3-cfb", "des-ede3-cfb1", "des-ede3-cfb8", "des-ede3-ofb", "des-ofb", "des3", "desx", "desx-cbc", "id-aes128-GCM", "id-aes192-GCM", "id-aes256-GCM", "rc2", "rc2-40-cbc", "rc2-64-cbc", "rc2-cbc", "rc2-cfb", "rc2-ecb", "rc2-ofb", "rc4", "rc4-40", "rc4-hmac-md5", "seed", "seed-cbc", "seed-cfb", "seed-ecb", "seed-ofb"]


=begin
man enc

des-cbc            DES in CBC mode
des                Alias for des-cbc
des-cfb            DES in CBC mode
des-ofb            DES in OFB mode
des-ecb            DES in ECB mode

des-ede-cbc        Two key triple DES EDE in CBC mode
des-ede            Two key triple DES EDE in ECB mode
des-ede-cfb        Two key triple DES EDE in CFB mode
des-ede-ofb        Two key triple DES EDE in OFB mode

des-ede3-cbc       Three key triple DES EDE in CBC mode
des-ede3           Three key triple DES EDE in ECB mode
des3               Alias for des-ede3-cbc
des-ede3-cfb       Three key triple DES EDE CFB mode
des-ede3-ofb       Three key triple DES EDE in OFB mode

=end




