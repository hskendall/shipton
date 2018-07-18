 package
{
	
	import com.adobe.crypto.SHA256;
	import com.hurlant.util.Hex;
	import com.king.encoder.Base58Encoder;
	import com.king.encoder.RippleBase58Encoder;
	import flame.crypto.RIPEMD160;
	import flash.utils.ByteArray;

	
	public class encodeKeys {

		public function encodeKeys()
		{
			

		}
		
		
		public function derivePubKeyHash(publicKey:ByteArray):String {

			var ripe:RIPEMD160 = new RIPEMD160();
			
			var riped:ByteArray = ripe.computeHash(Hex.toArray(SHA256.hashBytes(publicKey)));

			return Hex.fromArray(riped);
		}

		
		public function encodePrivateKey(privateKey:String,prefix:String):String {


			var encodedPrivateKey:ByteArray = new ByteArray();

			encodedPrivateKey.writeBytes(Hex.toArray(prefix));
			encodedPrivateKey.writeBytes(Hex.toArray(privateKey));
			
			var checksum:String = SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(encodedPrivateKey))).substr(0,8);

			encodedPrivateKey.writeBytes(Hex.toArray(checksum));
			encodedPrivateKey.position = 0;
			
			return Base58Encoder.encode(encodedPrivateKey);
		}


	}
}
