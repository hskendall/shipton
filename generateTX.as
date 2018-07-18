package  {
	
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import flame.crypto.RIPEMD160;
	import com.adobe.crypto.SHA256;
        import flame.crypto.ECDSA
	import encodeSig
	import flash.net.SharedObject
	import flash.net.dns.AAAARecord;
	import flame.crypto.ECCParameters
	import flame.crypto.ECDSASignatureDeformatter
	import flame.crypto.ECDSASignatureFormatter
	
        //This class generates hex TX from given parameters (inputs and outputs)
	//Bu sınıf transfer işlemini hex formatında oluşturur.
	
	public class generateTX {
		
    	public var encodeSigClass:encodeSig= new encodeSig()
		public var ECDSAclass:ECDSA = new ECDSA()

		var reversedData:String
		var endian:String
		
                var scriptSigArray:Array= new Array()


		public function generateTX() {

		}
		
		public function generateUnsignedTX(txids:Array, vouts:Array, amounts:Array, addresses:Array, pubKey:String):String {
			
		scriptSigArray= new Array()
		var walletInfo:SharedObject
		walletInfo = SharedObject.getLocal("walletInfo");
			
			
		for (var c:int = 0; c < txids.length; c++){


			var unsignedTX:ByteArray= new ByteArray()
			unsignedTX.writeBytes(Hex.toArray("01000000"))
			unsignedTX.writeBytes(Hex.toArray(     String(Number(txids.length).toString(16))     ))
			
			for (var i:int = 0; i < txids.length; i++){
				
				unsignedTX.writeBytes(Hex.toArray(reverseHashBytes(txids[i])))
				
				var hexIndex:String= ""
				
				if(String(Number(vouts[i]).toString(16)).length==1){
					hexIndex= "0"
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="000000"
				}
				
				else if(String(Number(vouts[i]).toString(16)).length==2){
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="000000"
				}
				
				else if(String(Number(vouts[i]).toString(16)).length==3){
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="00000"
				}
				
				else if(String(Number(vouts[i]).toString(16)).length==4){
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="0000"
				}

				unsignedTX.writeBytes(Hex.toArray(hexIndex))

					var ripe:RIPEMD160 = new RIPEMD160();
				
				
			if(c==i){
				unsignedTX.writeByte(0x19)
				unsignedTX.writeBytes(generateScriptPubKey(Hex.fromArray(ripe.computeHash(Hex.toArray(SHA256.hashBytes(Hex.toArray(walletInfo.data.publicKey)))))))
			}
			else{
				unsignedTX.writeByte(0x00)
			}
				
				unsignedTX.writeBytes(Hex.toArray("ffffffff"))

		}
			
			unsignedTX.writeBytes(Hex.toArray(     String(Number(amounts.length).toString(16))     ))
			
			for (var n:int = 0; n < Number(amounts.length); n++){
				
				unsignedTX.writeBytes(Hex.toArray(convertLittleEndian(amounts[n])))
				unsignedTX.writeByte(0x19)
				unsignedTX.writeBytes(generateScriptPubKey(addresses[n]))

			}
			
				unsignedTX.writeByte(0x00)
				unsignedTX.writeByte(0x00)
				unsignedTX.writeByte(0x00)
				unsignedTX.writeByte(0x00)
			
				unsignedTX.writeByte(0x01)
				unsignedTX.writeByte(0x00)
				unsignedTX.writeByte(0x00)
				unsignedTX.writeByte(0x00)
			
			generateScriptSig(unsignedTX,walletInfo.data.publicKey)
			
		}
			
	
			//var keyDataa:ECCParameters= new ECCParameters()
			//keyDataa= walletInfo.data.keyData
	
			
			//////ECDSAclass.deriveCorrespondingPubkey2(walletInfo.data.keyData.d)
			
			//ECDSAclass.importParameters(walletInfo.data.keyData.x,walletInfo.data.keyData.y,walletInfo.data.keyData.d)
			
			
			return generateSignedTX(txids,vouts,amounts,addresses)
			
	}
	
	var scriptSig:String
	var ECDSAsig:String
	
	public function generateScriptSig(unsignedTX:ByteArray,pubKey:String){
		ECDSAsig= signTX(SHA256.hashBytes(Hex.toArray(SHA256.hashBytes(unsignedTX))))

		scriptSig= String(Number(ECDSAsig.length/2).toString(16)) + ECDSAsig + String(Number(String(pubKey).length/2).toString(16)) + String(pubKey)

		scriptSigArray.push(scriptSig)
	}
	
		public function signTX(digest:String):String {
			
		var walletInfo:SharedObject
		walletInfo = SharedObject.getLocal("walletInfo");
			
		var ecdsa:ECDSA = new ECDSA(256);
		ecdsa.deriveCorrespondingPubkey2(walletInfo.data.keyData.d)

		var formatter:ECDSASignatureFormatter = new ECDSASignatureFormatter(ecdsa);

		var signature:ByteArray = formatter.createSignature(Hex.toArray(digest));

		var deformatter:ECDSASignatureDeformatter = new ECDSASignatureDeformatter(ecdsa);

		var valid:Boolean = deformatter.verifySignature(Hex.toArray(digest), signature);

			return Hex.fromArray(encodeSigClass.encodeSigParameters(Hex.fromArray(signature).substr(0,64),Hex.fromArray(signature).substr(64,64)))

		}

		public function generateSignedTX(txids:Array, vouts:Array, amounts:Array, addresses:Array):String {
				
		var walletInfo:SharedObject
		walletInfo = SharedObject.getLocal("walletInfo");


			var signedTX:ByteArray= new ByteArray()
			signedTX.writeBytes(Hex.toArray("01000000"))
			signedTX.writeBytes(Hex.toArray(     String(Number(txids.length).toString(16))     ))
			
			for (var i:int = 0; i < txids.length; i++){
				
				signedTX.writeBytes(Hex.toArray(reverseHashBytes(txids[i])))
				
				var hexIndex:String= ""
				
				if(String(Number(vouts[i]).toString(16)).length==1){
					hexIndex= "0"
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="000000"
				}
				
				else if(String(Number(vouts[i]).toString(16)).length==2){
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="000000"
				}
				
				else if(String(Number(vouts[i]).toString(16)).length==3){
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="00000"
				}
				
				else if(String(Number(vouts[i]).toString(16)).length==4){
					hexIndex+=String(Number(vouts[i]).toString(16))
					hexIndex+="0000"
				}

				signedTX.writeBytes(Hex.toArray(hexIndex))

				signedTX.writeBytes(Hex.toArray(String(Number(Number(String(scriptSigArray[i]).length)/2).toString(16))))
				
				signedTX.writeBytes(Hex.toArray(String(scriptSigArray[i])))
				
				signedTX.writeBytes(Hex.toArray("ffffffff"))
	
		}
			
			signedTX.writeBytes(Hex.toArray(     String(Number(amounts.length).toString(16))     ))
			
			for (var n:int = 0; n < Number(amounts.length); n++){
				
				signedTX.writeBytes(Hex.toArray(convertLittleEndian(amounts[n])))
				signedTX.writeByte(0x19)
				signedTX.writeBytes(generateScriptPubKey(addresses[n]))
			}
			
				signedTX.writeByte(0x00)
				signedTX.writeByte(0x00)
				signedTX.writeByte(0x00)
				signedTX.writeByte(0x00)
			
				return Hex.fromArray(signedTX)
	}
	
		public function convertLittleEndian(data:Number):String {
            var numberStr:String= ""
            endian= ""
			

			
            if(Number(data).toString(16).length%2==0){
				numberStr= String(Number(data).toString(16))
			}
			
			else {
				numberStr= String("0" + Number(data).toString(16))
			}
			
			endian= reverseHashBytes(numberStr)
			
			check()
			
				function check(){
				if(endian.length!=16){
					endian+="0"
					check()
				}
				else {
					
				}
			}
			
				return endian
	}
		
		public function reverseHashBytes(data:String):String{
			reversedData= ""
			var rArray:Array = data.split("")
			
			for (var i:int= data.length -2; i > -2; i+= -2){
				reversedData+= rArray[i]
				reversedData+= rArray[i+1]
			}
			
			return reversedData
		}
		
		public function generateScriptPubKey(pkh:String) {
			var ripe:RIPEMD160 = new RIPEMD160();
		        var scriptPubKey:ByteArray= new ByteArray()
			scriptPubKey.writeByte(0x76)
			scriptPubKey.writeByte(0xa9)
			scriptPubKey.writeByte(0x14)
			scriptPubKey.writeBytes(Hex.toArray(pkh))
			scriptPubKey.writeByte(0x88)
			scriptPubKey.writeByte(0xac)
			scriptPubKey.position= 0
			
            return scriptPubKey
		}
		
	}
	
}
