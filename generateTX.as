package  {
	
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import flame.crypto.RIPEMD160;
	import com.adobe.crypto.SHA256;
	
    //This class generates hex TX from given parameters (inputs and outputs)
	//Bu sınıf transfer işlemini hex formatında oluşturur.
	
	public class generateTX {
		
		var reversedData:String
		var endian:String

		public function generateTX() {

		}
		
		public function generateUnsignedTX(txids:Array, vouts:Array, amounts:Array, addresses:Array, pubKey:String) {

			var unsignedTX:ByteArray= new ByteArray()
			unsignedTX.writeBytes(Hex.toArray("01000000"))
			unsignedTX.writeBytes(Hex.toArray(String("0" + txids.length)))
			
			for (var i:int = 0; i < txids.length; i++){
				
				unsignedTX.writeBytes(Hex.toArray(reverseHashBytes(txids[i])))

				var hexIndex:String= String(Number(vouts[i]).toString(16))

				var hexIndexLength:Number= hexIndex.length
				
				if(hexIndexLength % 2==0){
					
				}
				else{
	
					hexIndex= "0" + hexIndex
					hexIndexLength= hexIndex.length
				}
				
				if(hexIndex.length>=4){
				hexIndex= reverseHashBytes(hexIndex).substr(0,hexIndexLength)
				}
				
			    check()
				
				function check(){
				if(hexIndex.length!=8){
					hexIndex+="0"
					check()
				}
				else {
					
				}
				}
				
				unsignedTX.writeBytes(Hex.toArray(hexIndex))

				
				
				unsignedTX.writeByte(0x00)
				unsignedTX.writeBytes(Hex.toArray("ffffffff"))

			
			
		}
			
			unsignedTX.writeBytes(Hex.toArray(String("0" + amounts.length)))
			
			for (var n:int = 0; n < amounts.length; n++){
				
				unsignedTX.writeBytes(Hex.toArray(convertLittleEndian(amounts[n])))
				unsignedTX.writeByte(0xee)
			}
			trace(Hex.fromArray(unsignedTX))
			

		
		
	}
		
		public function generateSignedTX() {
			// constructor code
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
		
		public function generateScriptPubKey(pubKey:String) {
			var ripe:RIPEMD160 = new RIPEMD160();
		    var scriptPubKey:ByteArray= new ByteArray()
			scriptPubKey.writeByte(0x76)
			scriptPubKey.writeByte(0xa9)
			scriptPubKey.writeByte(0x14)
			scriptPubKey.writeBytes(ripe.computeHash(Hex.toArray(SHA256.hashBytes(Hex.toArray(pubKey)))))
			scriptPubKey.writeByte(0x88)
			scriptPubKey.writeByte(0xac)
			scriptPubKey.position= 0
			
            return scriptPubKey
		}
		

	}
	
}
