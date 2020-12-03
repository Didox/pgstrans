using System;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;

namespace ConsoleTeste
{
    class Program
    {
        static void Main(string[] args)
        {
            var agentKey = Environment.GetEnvironmentVariable("KEY");
            var userId = Environment.GetEnvironmentVariable("USER");
            var requestTime = Environment.GetEnvironmentVariable("REQUESTTIME");

            //var agentKey = "6b6579303030";
            //var userId = "123";
            //var requestTime = "20191228083500";

            var message = requestTime + userId;

            string str3 = Encryption.HashHMACHex(agentKey, message);

            Console.WriteLine(str3);
        }
    }
}

public static class Encryption
{
    private static string ByteArrayToHexString(byte[] bytes)
    {
        StringBuilder builder = new StringBuilder(bytes.Length * 2);
        foreach (byte num in bytes)
        {
            builder.AppendFormat("{0:x2}", num);
        }
        return builder.ToString();
    }

    public static string Decrypt(string cipherString, bool useHashing)
    {
        byte[] buffer;
        string s = "xxxxxxxxxx";
        byte[] inputBuffer = Convert.FromBase64String(cipherString);
        if (!useHashing)
        {
            buffer = Encoding.UTF8.GetBytes(s);
        }
        else
        {
            MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider();
            buffer = provider.ComputeHash(Encoding.UTF8.GetBytes(s));
            provider.Clear();
        }
        TripleDESCryptoServiceProvider provider2 = new TripleDESCryptoServiceProvider
        {
            Key = buffer,
            Mode = CipherMode.ECB,
            Padding = PaddingMode.PKCS7
        };
        byte[] bytes = provider2.CreateDecryptor().TransformFinalBlock(inputBuffer, 0, inputBuffer.Length);
        provider2.Clear();
        return Encoding.UTF8.GetString(bytes);
    }

    public static string Encrypt(string toEncrypt, bool useHashing)
    {
        string s = "xxxxxxxxxx";
        byte[] bytes = Encoding.UTF8.GetBytes(toEncrypt);
        byte[] inputBuffer = Encoding.UTF8.GetBytes(toEncrypt);
        if (!useHashing)
        {
            bytes = Encoding.UTF8.GetBytes(s);
        }
        else
        {
            MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider();
            bytes = provider.ComputeHash(Encoding.UTF8.GetBytes(s));
            provider.Clear();
        }
        TripleDESCryptoServiceProvider provider2 = new TripleDESCryptoServiceProvider
        {
            Key = bytes,
            Mode = CipherMode.ECB,
            Padding = PaddingMode.PKCS7
        };
        byte[] inArray = provider2.CreateEncryptor().TransformFinalBlock(inputBuffer, 0, inputBuffer.Length);
        provider2.Clear();
        return Convert.ToBase64String(inArray, 0, inArray.Length);
    }

    private static string HashEncode(byte[] hash) =>
        BitConverter.ToString(hash).Replace("-", "").ToLower();

    private static byte[] HashHMAC(byte[] key, byte[] message)
    {
        return new HMACSHA256(key).ComputeHash(message);
    }

    public static string HashHMACHex(string keyHex, string message)
    {
        var exDec = HexDecode(keyHex);
        var str = StringEncode(message);
        var encode = HashEncode(HashHMAC(exDec, str));
        return encode;
    }

    private static byte[] HexDecode(string hex)
    {
        byte[] buffer = new byte[hex.Length / 2];
        for (int i = 0; i < buffer.Length; i++)
        {
            buffer[i] = byte.Parse(hex.Substring(i * 2, 2), NumberStyles.HexNumber);
        }
        return buffer;
    }

    private static byte[] HexStringToByteArray(string hexString)
    {
        int length = hexString.Length;
        byte[] buffer = new byte[length / 2];
        for (int i = 0; i < length; i += 2)
        {
            buffer[0] = Convert.ToByte(hexString.Substring(i, 2), 0x10);
        }
        return buffer;
    }

    private static byte[] StringEncode(string text) =>
        new ASCIIEncoding().GetBytes(text);
}