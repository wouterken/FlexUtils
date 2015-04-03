package com.littlecoder.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.Base64Encoder;

	public class FileUtils
	{
		public static function readFileAsUTF(file:File):String{
			const stream:FileStream = new FileStream;
			var asUTF:String = "";
			
			if(!file)
				throw new Error("File must be a valid file object");
			
			if(!file.exists)
				throw new Error("File must exist");
			
			stream.open(file, FileMode.READ);
			asUTF = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			return asUTF;
		}
		
		public static function readBits(file:File):String{
			const stream:FileStream = new FileStream;
			
			var bits:Array = [];
			
			if(!file)
				throw new Error("File must be a valid file object");
			
			if(!file.exists)
				throw new Error("File must exist");
			var bytes:ByteArray = new ByteArray;
			
			stream.open(file, FileMode.READ);
			
			stream.readBytes(bytes);
			stream.close();
			bytes.position = 0;
			
			return Base64.encodeByteArray(bytes);
		}
		
		public static function appendUTFFile(file:File, value:String):Boolean{
			const stream:FileStream = new FileStream;
			var asUTF:String = "";
			
			if(!file)
				throw new Error("File must be a valid file object");
			
			
			stream.open(file, FileMode.APPEND);
			stream.writeUTFBytes(value);
			stream.close();
			
			return true;
		}
		
		public static function writeUTFFile(file:File, value:String):Boolean{
			const stream:FileStream = new FileStream;
			var asUTF:String = "";
			
			if(!file)
				throw new Error("File must be a valid file object");
			
			
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(value);
			stream.close();
			
			return true;
		}
		
		public static function bytesToHumanSize(size:Number, precision:int = 1, base:Number = 1000):String{
			
			const suffixes:Array = ["bytes","kb","mb","gb","tb"];
			
			var suffixIdx:int = 0;
			
			while(size > base && suffixIdx < suffixes.length){
				suffixIdx++;
				size /= base;
			}
			
			return size.toFixed(precision) + suffixes[suffixIdx];
		}
	}
}