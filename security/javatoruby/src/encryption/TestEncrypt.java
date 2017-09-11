package encryption;

import java.security.Key;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
//import javax.crypto.spec.DESKeySpec;
import it.sauronsoftware.base64.Base64;
import java.security.SecureRandom;

/*
KeyGenerator =>
AES (128)
DES (56)
DESede (168)
HmacSHA1
HmacSHA256

SecretKeyFactory=>
DES
DESede

AlgorithmParameters=>
AES
DES
DESede
DiffieHellman
DSA

https://docs.oracle.com/javase/7/docs/technotes/guides/security/StandardNames.html
*/
public class TestEncrypt{ 
  public static final String seed="idesseedche";

  //定义密钥加密算法,可用 DES,DESede,Blowfish 
  public static final String KEY_ALGORITHM="DESede"; 
  //public static final String KEY_ALGORITHM="DES";
    
  /** 
   * 加密/解密算法/工作模式/填充方式 
   * */  
  //public static final String CIPHER_ALGORITHM="DESede/ECB/PKCS5Padding";
  public static final String CIPHER_ALGORITHM="DESede";

  /*
  AES/CBC/NoPadding (128)
	AES/CBC/PKCS5Padding (128)
	AES/ECB/NoPadding (128)
	AES/ECB/PKCS5Padding (128)
	DES/CBC/NoPadding (56)
	DES/CBC/PKCS5Padding (56)
	DES/ECB/NoPadding (56)
	DES/ECB/PKCS5Padding (56)
	DESede/CBC/NoPadding (168)
	DESede/CBC/PKCS5Padding (168)
	DESede/ECB/NoPadding (168)
	DESede/ECB/PKCS5Padding (168)
	RSA/ECB/PKCS1Padding (1024, 2048)
	RSA/ECB/OAEPWithSHA-1AndMGF1Padding (1024, 2048)
	RSA/ECB/OAEPWithSHA-256AndMGF1Padding (1024, 2048)


   A transformation is of the form:
    "algorithm/mode/padding" or
    "algorithm" 

  (in the latter case, provider-specific default values for the mode and padding scheme are used). For example, the following is a valid transformation:
    Cipher c = Cipher.getInstance("DES/CBC/PKCS5Padding");
  */
  
  /** 
   *  
   * 生成密钥，java7支持112 或 168位密钥
   * @return byte[] 二进制密钥 
   * */  
  public static byte[] initkey() throws Exception{          
    //实例化密钥生成器  
    KeyGenerator kg=KeyGenerator.getInstance(KEY_ALGORITHM);  
    //初始化密钥生成器  
    kg.init(168);
    //kg.init(56);  
    //生成密钥  
    SecretKey secretKey=kg.generateKey();  
    //获取二进制密钥编码形式  
    return secretKey.getEncoded();  
  }  
  /** 
   * 转换密钥 
   * @param key 二进制密钥 
   * @return Key 密钥 
   * */  
  public static Key toKey(byte[] key) throws Exception{  
    //实例化密钥  
    DESedeKeySpec dks = new DESedeKeySpec(key);
    //DESKeySpec dks = new DESKeySpec(key); 
    //实例化密钥工厂  
    SecretKeyFactory keyFactory=SecretKeyFactory.getInstance(KEY_ALGORITHM);  
    //生成密钥  
    SecretKey secretKey=keyFactory.generateSecret(dks);  
    return secretKey;  
  }  
    
  /** 
   * 加密数据 
   * @param data 待加密数据 
   * @param key 密钥 
   * @return byte[] 加密后的数据 
   * */  
  public static byte[] encrypt(byte[] data,byte[] key) throws Exception{  
    //还原密钥  
    Key k=toKey(key);  
    //实例化  
    Cipher cipher=Cipher.getInstance(CIPHER_ALGORITHM);  
    //初始化，设置为加密模式  
    
    SecureRandom sr = new SecureRandom(seed.getBytes());
    cipher.init(Cipher.ENCRYPT_MODE, k, sr);
    //cipher.init(Cipher.ENCRYPT_MODE, k);  
    //执行操作  
    return cipher.doFinal(data);  
  }  
  /** 
   * 解密数据 
   * @param data 待解密数据 
   * @param key 密钥 
   * @return byte[] 解密后的数据 
   * */  
  public static byte[] decrypt(byte[] data,byte[] key) throws Exception{  
    //还原密钥  
    Key k =toKey(key);  
    //实例化  
    Cipher cipher=Cipher.getInstance(CIPHER_ALGORITHM);  
    //初始化，设置为解密模式  

    SecureRandom sr = new SecureRandom(seed.getBytes());
    cipher.init(Cipher.DECRYPT_MODE, k, sr);
    //cipher.init(Cipher.DECRYPT_MODE, k);  
    //执行操作  
    return cipher.doFinal(data);  
  }  

  public static String showByteArray(byte[] data){
    if(null==data){
      return null;
    }
    StringBuilder sb=new StringBuilder("{");
    for(byte b: data){
      sb.append(b).append(",");
    }
    sb.deleteCharAt(sb.length()-1);
    sb.append("}");
    return sb.toString();
  }

  public static void main(String[] args) throws Exception {
    String _key="s56dZN+kAY+KwshANAeAlA6P5f5FNCp5";
    String decodedKey = Base64.decode(_key, "UTF-8");
    System.out.println("_key:"+_key);
    System.out.println("after decode:"+showByteArray(decodedKey.getBytes()));

    String input="helloworld";
    String str=Base64.encode(input,"UTF-8");  
    System.out.println("原文："+input);  
    //初始化密钥  
    byte[] key=initkey();  
    System.out.println("密钥："+showByteArray(key));
    System.out.println("密钥："+Base64.encode(key.toString(),"UTF-8"));

    //加密数据  
    byte[] data=encrypt(str.getBytes(), key);
    System.out.println("密文："+showByteArray(data));  
    System.out.println("密文："+Base64.encode(data.toString(),"UTF-8"));
    System.out.println("密文："+Hex.encodeHexStr(data));
  
    //解密数据  
    data=decrypt(data, key);  
    System.out.println("解密后："+Base64.decode(new String(data),"UTF-8")); 

    //decodedKey加密数据  
    byte[] _data=encrypt(str.getBytes(), decodedKey.getBytes());  
    //System.out.println("decodedKey加密原文后："+Base64.encode(_data.toString(),"UTF-8"));
    System.out.println("decodedKey加密原文后："+Hex.encodeHexStr(_data,false));

    String decoded="AE86424DA886538A7D928D8209C056B3C6E080584318D60F";
    byte[] hex=Hex.decodeHex(decoded.toCharArray());
    String decodeStr = new String(hex);
    System.out.println();    
    System.out.println("decoded hex："+showByteArray(hex));

    byte[] data_str=decrypt(decodeStr.getBytes(), decodedKey.getBytes());  
    System.out.println("解密后："+new String(data_str)); 
  } 
}


/*
cd /home/simon/Desktop/security/javatoruby/src
javac -d ./ encryption/Hex.java
javac -d ./ encryption/TestEncrypt.java 
java encryption.TestEncrypt
*/

/*
简介：

数据加密算法（Data Encryption Algorithm，DEA）是一种对称加密算法，很可能是使用最广泛的密钥系统，特别是在保护金融数据的安全中，最初开发的DEA是嵌入硬件中的。通常，自动取款机（Automated Teller Machine，ATM）都使用DEA。它出自IBM的研究工作，IBM也曾对它拥有几年的专利权，但是在1983年已到期后，处于公有范围中，允许在特定条件下可以免除专利使用费而使用。1977年被美国政府正式采纳。

1998年后实用化DES破译机的出现彻底宣告DES算法已不具备安全性，1999年NIST颁布新标准，规定DES算法只能用于遗留加密系统，但不限制使用DESede算法。当今DES算法正式退出历史舞台，AES算法称为他的替代者。

加密原理：
DES使用一个56位的密钥以及附加的8位奇偶校验位，产生最大64位的分组大小。这是一个迭代的分组密码，使用称为 Feistel 的技术，其中将加密的文本块分成两半。使用子密钥对其中一半应用循环功能，然后将输出与另一半进行“异或”运算；接着交换这两半，这一过程会继续下去，但最后一个循环不交换。DES使用16个循环，使用异或，置换，代换，移位操作四种基本运算。


Java加密解密之对称加密算法DESede

密钥长度：112位/168位
工作模式：ECB/CBC/PCBC/CTR/CTS/CFB/CFB8 to CFB128/OFB/OBF8 to OFB128
填充方式：NoPadding/PKCS5Padding/ISO10126Padding/


DESede即三重DES加密算法，也被称为3DES或者Triple DES。使用三(或两)个不同的密钥对数据块进行三次(或两次)DES加密(加密一次要比进行普通加密的三次要快)。三重DES的强度大约和112-bit的密钥强度相当。通过迭代次数的提高了安全性，但同时也造成了加密效率低的问题。正因DESede算法效率问题，AES算法诞生了。

到目前为止，还没有人给出攻击三重DES的有效方法。对其密钥空间中密钥进行蛮干搜索，那么由于空间太大，这实际上是不可行的。若用差分攻击的方法，相对于单一DES来说复杂性以指数形式增长。

三重DES有四种模型

DES-EEE3，使用三个不同密钥，顺序进行三次加密变换。
DES-EDE3，使用三个不同密钥，依次进行加密-解密-加密变换。
DES-EEE2，其中密钥K1=K3，顺序进行三次加密变换。
DES-EDE2，其中密钥K1=K3，依次进行加密-解密-加密变换。
*/

