package  {
	
	import flash.events.Event;
	import flash.net.URLRequest
	import flash.net.URLVariables
	import flash.net.URLLoader
	import flash.net.URLRequestMethod
	import flash.net.URLLoaderDataFormat
	
	
	public class getExchangeRate {
		
		public var rawResponseArray:Array
		public var responseArray:Array
		public var rawRateArray:Array
		public var rateArray:Array= new Array();
		

		public function getExchangeRate() {

		}
		
		public function init(localCurrency:String) {

		var request:URLRequest=new URLRequest ("https://shipton.io/currencyexchange/getcurrencyvalue.php");
		request.method=URLRequestMethod.POST;
 
		var send:URLVariables=new URLVariables();
 
		send.localcurrency= localCurrency
		request.data=send;
 
		var loader:URLLoader=new URLLoader (request);
		loader.addEventListener(Event.COMPLETE, response);
		loader.dataFormat=URLLoaderDataFormat.VARIABLES;
		loader.load(request);
			
 
		function response (event:Event):void{
	
		rawResponseArray=String(event.target.data.data).split("}")
	
		responseArray= String(rawResponseArray[0]).split(",")

		for (var i:Number= 0; i< responseArray.length; i++){
		rateArray.push(responseArray[i].split(":")[1])

		if(i== responseArray.length-1){
		//callback(rateArray)
		}

}
}


			
			
		}
		
		
		

	}
	
}
