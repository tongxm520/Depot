package encryption;

import java.io.*;
import java.security.*;
import java.math.*;
import cryptix.util.core.BI;
import cryptix.util.core.ArrayUtil;
import cryptix.util.core.Hex;
import cryptix.provider.key.*;
import xjava.security.Cipher;

class EncryptNoPadding {
	public static void main (String[] args) {
		try {
			FileOutputStream outFile1 = new FileOutputStream("DES-EDE3.out");
			// Note: PrintStream is deprecated, but still works fine in jdk1.1.7b
			PrintStream output1 = new PrintStream(outFile1);

			// convert a string to a 3DES key and print out the result
			RawSecretKey key2 = new RawSecretKey("DES-EDE3",Hex.fromString("3812A419C63BE771AD9F61FEFA20CE633812A419C63BE771"));
			RawKey rkey = (RawKey) key2;
			byte[] yval = rkey.getEncoded();
			BigInteger Bkey = new BigInteger(yval);
			String w = cryptix.util.core.BI.dumpString(Bkey);
			output1.println("The Encryption Key = " + w);
	
			// use the 3DES key to encrypt a string in electronic code book (ECB) mode
			Cipher des=Cipher.getInstance("DES-EDE3/ECB/NONE","Cryptix");
			des.initEncrypt(key2);	
			byte[] ciphertext = des.crypt(Hex.fromString("01010101010101010102030405060708090A0B0C0D0E0F101112131415161718"));

			// print out length and representation of ciphertext 
			output1.print("\n");
			output1.println("ciphertext.length = " + ciphertext.length);

			BigInteger Bciph = new BigInteger(ciphertext);
			w = cryptix.util.core.BI.dumpString(Bciph);
			output1.println("Ciphertext for 3DES encryption = " + w);
	
			// decrypt ciphertext 
			des.initDecrypt(key2);
			ciphertext = des.crypt(ciphertext);
			output1.print("\n");
			output1.println("plaintext.length = " + ciphertext.length);

			// print out representation of decrypted ciphertext 
			Bciph = new BigInteger(ciphertext);
			w = cryptix.util.core.BI.dumpString(Bciph);
			output1.println("Plaintext for 3DES encryption = " + w);

			output1.println(" ");
			output1.close();		

		} catch (Exception e) {
		  System.err.println("Caught exception " + e.toString());
		}
	}
}


/*
cd /home/simon/Desktop/security/javatoruby/src
javac -d ./ encryption/Hex.java
javac -d ./ encryption/EncryptNoPadding.java 
java encryption.EncryptNoPadding
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


/*
byte[] data_str=decrypt(decodeStr.getBytes(), decodedKey.getBytes()); 

Exception in thread "main" javax.crypto.IllegalBlockSizeException: Input length must be multiple of 8 when decrypting with padded cipher


Using "DESede/ECB/PKCS5Padding" will do the trick.
cipher = Cipher.getInstance("DESede/ECB/PKCS5Padding");
If you use NoPadding, then you must implement your own padding for encryption, and make sure to remove it from the resulting string in decryption.
*/
