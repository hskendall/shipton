package  {
	
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.SharedObject
	import com.hurlant.util.Hex;
	import ECDSA_keypair
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
	import flash.display.Stage
	
	
	public class shipton extends MovieClip {

	public var logInfo:SharedObject
	public var walletInfo:SharedObject
	public var keyData:ECCParameters= new ECCParameters()
		
	public var ECDSA_keypairClass:ECDSA_keypair= new ECDSA_keypair()
	public var encodeSigClass:encodeSig= new encodeSig()
	public var generateTXClass:generateTX= new generateTX()
	public var ECDSAclass:ECDSA = new ECDSA()
	public var deriveAddressClass:deriveAddress= new deriveAddress()
	public var getExchangeRateClass:getExchangeRate= new getExchangeRate()
    public var rippleFamilyClass:rippleFamily= new rippleFamily()
		
    public var localCurrency:String= "USD"
	public var cryptocurrencyNameArray:Array= new Array("Bitcoin", "Ethereum", "Litecoin", "Ripple", "Dash", "Z-Cash" , "Dogecoin");
	public var cryptocurrencySymbolArray:Array= new Array("BTC", "ETH", "LTC", "XRP", "DASH", "ZEC", "DOGE");
		
	public var TXInput_txid:Array = new Array()
	public var TXInput_vout:Array = new Array()
	public var TXOutput_amount:Array = new Array()
	public var TXOutput_address:Array = new Array()
		
		
		public function shipton() {
		
			init()
			
			//generateRawTX()
			
			//logWallet()
			
		}
		
		
		public function init() {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			
			
			//Importing wallet files from wallet's local memory.
			//Yerel hafızadan cüzdan bilgilerini çekiyoruz.
			logInfo = SharedObject.getLocal("logInfo");
			walletInfo = SharedObject.getLocal("walletInfo");
			
			//Getting recent exchange rates.
			//Güncel kur bilgilerini çekiyoruz.
			getExchangeRateClass.init(localCurrency)			
			
			if(logInfo.data.logBoo==true){
				//this.logWallet()
			}
			
			else {
				this.generateWallet()	
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
			walletInfo.data.privateKey= Hex.fromArray(privateKey)
			walletInfo.data.compressedPublicKey= Hex.fromArray(compressedPublicKey)
		
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
			
			logInfo.data.logBoo= true
		
			walletInfo.flush()
			logInfo.flush()
		
		}

		public function generateRawTX() {
			
			//TXInput_txid.push()
			//TXInput_vout.push()
			//TXOutput_amount.push()
			//TXOutput_address.push()
			
			//Calling "generateUnsignedTX" function from generateTX class to encoude unsigned hex TX by given related parameters.
			//Hex formatında imzalanmamış bir işlem oluşturmak için ilgili paramatreleri girerek generateTX sınıfından "generateUnsignedTX" fonksiyonunu çağırıyoruz.
			generateTXClass.generateUnsignedTX(TXInput_txid, TXInput_vout, TXOutput_amount, TXOutput_address, walletInfo.data.publicKey)
			
		}
		
		
		
	}
	
}
