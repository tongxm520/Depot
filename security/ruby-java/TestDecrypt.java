import java.security.*;
import java.*;
import java.io.*;
import javax.crypto.*;
import javax.crypto.spec.*;

public class TestDecrypt{
  public static void main(String[] args) throws Exception {
    byte[] key = hexDecode("b4add9a5ea6a61ef7582a95af5e2f56ed97bbd7413e7cd77");
    byte[] iv = hexDecode("b55e5e18d3ae9c26");

    // Init the key
    System.out.println("after hexDecode:"+key);
    DESedeKeySpec desKeySpec = new DESedeKeySpec(key);
    SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DESede");
    Key secretKey = keyFactory.generateSecret(desKeySpec);

    IvParameterSpec ivSpec = new IvParameterSpec(iv);
    Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
    cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec);

    byte[] buf = new byte[1024];
    InputStream input = new FileInputStream(new File("enc.txt"));
    FileOutputStream output = new FileOutputStream(new File("dec.txt"));

    int count = input.read(buf);

    // Read and decrypt file content
    while (count >= 0) {
        output.write(cipher.update(buf, 0, count)); 
        count = input.read(buf);        
    }
    output.write(cipher.doFinal());
    output.flush();
  }

  public static byte[] hexDecode(String hex) {
    ByteArrayOutputStream bas = new ByteArrayOutputStream();
    for(int i=0;i< hex.length(); i+=2) {
      int b = Integer.parseInt(hex.substring(i, i+2), 16);
      bas.write(b);
    }
    return bas.toByteArray();
  }
}
