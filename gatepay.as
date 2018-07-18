package  {
	

	import flash.net.SharedObject
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import deriveAddress
	import com.king.encoder.RippleBase58Encoder;
	import flame.utils.ByteArrayUtil;
	import rippleFamily
	import flame.crypto.ECCParameters
        import flame.crypto.ECDSA
        import flame.crypto.asn1.ASN1BMPString
	import com.adobe.crypto.SHA256;
	import com.hurlant.util.der.ByteString
	import com.hurlant.util.der.DER
	import com.hurlant.util.der.IAsn1Type
	import com.hurlant.util.der.Integer;
	import flame.numerics.BigInteger;
	import encodeSig
        import generateTX
	import checkAddress
	import flash.display.Stage
	import com.king.encoder.Base58Encoder;
	import encodeKeys

	
	
	public class gatepay extends MovieClip {
		
		
		

	public var logInfo:SharedObject
	public var walletInfo:SharedObject
	public var keyData:ECCParameters= new ECCParameters()
		
	public var encodeSigClass:encodeSig= new encodeSig()
	public var generateTXClass:generateTX= new generateTX()
	public var ECDSAclass:ECDSA = new ECDSA()
	public var deriveAddressClass:deriveAddress= new deriveAddress()
	public var getExchangeRateClass:getExchangeRate= new getExchangeRate()
        public var rippleFamilyClass:rippleFamily= new rippleFamily()
	public var checkAddressClass:checkAddress= new checkAddress()
	public var encodeKeysClass:encodeKeys= new encodeKeys()
	
        public var localCurrency:String= "USD"
	public var cryptocurrencyNameArray:Array= new Array("Bitcoin", "Ethereum", "Litecoin", "Ripple", "Dash", "Z-Cash" , "Dogecoin");
	public var cryptocurrencySymbolArray:Array= new Array("BTC", "ETH", "LTC", "XRP", "DASH", "ZEC", "DOGE");
		
	public var TXInput_txid:Array = new Array()
	public var TXInput_vout:Array = new Array()
	public var TXOutput_amount:Array = new Array()
	public var TXOutput_address:Array = new Array()
		
		
		public function gatepay() {
		
			init()
			
			//generateRawTX()
			
			//logWallet()
			
		}
		
	
		
		public function init() {
			
			//Importing wallet files from wallet's local memory.
			//Yerel hafızadan cüzdan bilgilerini çekiyoruz.
			logInfo = SharedObject.getLocal("logInfo");
			walletInfo = SharedObject.getLocal("walletInfo");

			

			//Getting recent exchange rates.
			//Güncel kur bilgilerini çekiyoruz.
			getExchangeRateClass.init(localCurrency)			
			
			if(logInfo.data.logBoo==true){
			//this.logWallet()
			this.gotoAndStop(4)
			}
			
			else {
			this.gotoAndStop(5)
			}
			
		
		}
		
		

		
		

		
		
		public function generateWallet():void {
			
			var privateKey:ByteArray = new ByteArray();
			var publicKey:ByteArray = new ByteArray();
			var compressedPublicKey:ByteArray = new ByteArray();
	    
			//Calling "exportParameters" function from ECDSA class to generate unique corresponding ECDSA keypairs.
        	        //İlgili ECDSA anahtar çiftlerini oluşturmak için ECDSA sınıfından "exportParameters" fonksiyonunu çağırıyoruz.
        	        keyData= ECDSAclass.exportParameters(true)
			

			//Initializing public key by adding related prefix.
			//Açık anahtarımıza ilgili ön ekini ekliyoruz.
			publicKey.writeByte(0x04);
			compressedPublicKey.writeByte(0x03);
			
			//Deriving public key from x,y parameters.
			//Açık anahtarımızı ECDSA x,y parametlerine dayanarak türetiyoruz.
			privateKey.writeBytes(keyData.d); //.d
			publicKey.writeBytes(keyData.x); //.x
			publicKey.writeBytes(keyData.y); //.y
			compressedPublicKey.writeBytes(keyData.x);
			
			privateKey.position= 0
			publicKey.position= 0
			compressedPublicKey.position= 0
			
			
		
			//Assigning keypairs to the local wallet memory.
			//Anahtar ikililerini cüzdan yerel hafızasına atıyoruz.
			walletInfo.data.publicKey= Hex.fromArray(publicKey)
			walletInfo.data.pkh= deriveAddressClass.derivePubKeyHash(publicKey)
			trace("amqbe: "+walletInfo.data.pkh)
			walletInfo.data.privateKey= Hex.fromArray(privateKey)
			walletInfo.data.compressedPublicKey= Hex.fromArray(compressedPublicKey)
			
			walletInfo.data.keyData= keyData
			
			trace("PRIKEYIS: "+walletInfo.data.privateKey)
			trace("PUBKEYIS: "+walletInfo.data.publicKey)
			
			
		
		
			//Deriving cryptocurrency addresses from single ECDSA public key.
			//Adresleri tek bir ECDSA anahtarı üzerinden türetiyoruz.
			walletInfo.data.bitcoinAddress= deriveAddressClass.deriveBitcoinAddress(publicKey)
			walletInfo.data.litecoinAddress= deriveAddressClass.deriveLitecoinAddress(publicKey)
			walletInfo.data.dashAddress= deriveAddressClass.deriveDashAddress(publicKey)
			walletInfo.data.dogeAddress= deriveAddressClass.deriveDogeAddress(publicKey)
			walletInfo.data.zcashAddress= deriveAddressClass.deriveZCashAddress(publicKey)
			//walletInfo.data.ethereumAddress= deriveAddressClass.deriveEthereumAddress(compressedPublicKey)
			walletInfo.data.rippleAddress= deriveAddressClass.deriveRippleAddress(compressedPublicKey)
			//walletInfo.data.neoAddress= deriveAddressClass.deriveNeoAddress(publicKey)
			
			walletInfo.data.pubKeyHash= deriveAddressClass.derivePubKeyHash(publicKey)
			
			
			logInfo.data.logBoo= true
		
			walletInfo.flush()
			logInfo.flush()
		
		}

		public function generateRawTX(TXInput_txid:Array,TXInput_vout:Array,TXOutput_amounts:Array,TXOutput_address:Array):String {
			
			
			//TXInput_txid.push()
			//TXInput_vout.push()
			//TXOutput_amount.push()
			//TXOutput_address.push()
			
			//Calling "generateUnsignedTX" function from generateTX class to encoude unsigned hex TX by given related parameters.
			//Hex formatında imzalanmamış bir işlem oluşturmak için ilgili paramatreleri girerek generateTX sınıfından "generateUnsignedTX" fonksiyonunu çağırıyoruz.
			return generateTXClass.generateUnsignedTX(TXInput_txid, TXInput_vout, TXOutput_amounts, TXOutput_address, walletInfo.data.publicKey)
			
		}
		
		
        public function decodeAddress(address:String):String {
			return(           Hex.fromArray(Base58Encoder.decode( address) )          )
		}

		
	}
	
}
