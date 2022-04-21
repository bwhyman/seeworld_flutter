import 'dart:convert';
import 'package:crypto/crypto.dart';

const String _accessKey = '6d6cda55d66b4a16ab4f678cc264f7d3';
const String _secretKey = '925ac8e29fac4553babc525ca2a6538a';

class Signature {
  static String getSignature(String apiurl, String method) {
    String timestamp = DateTime.now()
            .toLocal()
            //.subtract(const Duration(hours: -8))
            .toIso8601String()
            .substring(0, 19) +
        'Z';
    timestamp = timestamp.replaceAll(':', '%3A');
    String url =
        'AccessKey=$_accessKey&SignatureMethod=HmacSHA1&SignatureNonce=9d81ffbeaaf7477390db5df577bb3298&SignatureVersion=V2.0&Timestamp=$timestamp&Version=2016-12-05';
    var base = apiurl.replaceAll('/', '%2F');
    var digest = sha256.convert(utf8.encode(url));
    String stringToSign = '$method\n$base\n$digest';
    String acc = 'BC_SIGNATURE&$_secretKey';
    var sign = Hmac(sha1, utf8.encode(acc)).convert(utf8.encode(stringToSign));
    return '$apiurl?$url&Signature=$sign';
  }
}
