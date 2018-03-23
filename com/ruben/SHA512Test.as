////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.ruben
{
	import com.ruben.SHA512;
	
	import flash.utils.ByteArray;

	[TestCase(order=7)]
	public final class SHA512Test extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SHA512Test()
		{
			super();
			
			_hashAlgorithm = new SHA512();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		


		public function hash(passphrase:String):ByteArray
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes(passphrase);
			
			return computeHashAndTest(data);
		}
		
		public function hashHex(hexData:ByteArray):ByteArray
		{
			var data2:ByteArray = new ByteArray();
			
			data2.writeBytes(hexData);
			
			return computeHashAndTest(data2);
		}

	}
}