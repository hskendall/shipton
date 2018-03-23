package  {

	import flash.utils.ByteArray;
	import com.hurlant.util.Hex;
	import flame.utils.ByteArrayUtil;
	import rippleFamily
	import flame.crypto.ECCParameters
    import flame.crypto.ECDSA
    import flame.crypto.asn1.ASN1BMPString
    import com.hurlant.util.der.Integer;

	public class signTX {
		
	public var ECDSAclass:ECDSA = new ECDSA()

		public function signTX() {
			// constructor code
		}
		
		
		public function signRawTX(txHash:String):Number {

			return ECDSAclass.signHash( Hex.toArray(txHash)))
			
		}
		
		
	
		

	}
	
}
