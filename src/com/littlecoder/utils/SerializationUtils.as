package com.littlecoder.utils
{
    import com.adobe.serializers.json.JSONEncoder;
    
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.xml.XMLDocument;
    import flash.xml.XMLNode;
    
    import mx.rpc.xml.SimpleXMLDecoder;
    import mx.rpc.xml.SimpleXMLEncoder;
    import mx.utils.ObjectProxy;
    import mx.utils.object_proxy;
    
    public class SerializationUtils
    {
        public static const xmlDecoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
        public static const xmlEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(new XMLDocument());
        public static const jsonEncoder:JSONEncoder = new JSONEncoder();
        public static const jsonDecode:Function = JSONDecoder.initDecodeJson();
        
        public static function objectToXML(item:Object, itemName:String):XML
        {
            
            
            
            const xmlAsNode:XMLNode = xmlEncoder.encodeValue(item, new QName(itemName), new XMLNode(1, ""));
            const xml:XML = new XML(xmlAsNode.toString());
            
            
            
            return xml;
        }
        
        
        public static function XMLToObject(xml:String):Object{
            
            
            
            const proxy:Object = xmlDecoder.decodeXML(new XMLDocument(xml));
            const xmlObject:Object = new Object();
            
            if(proxy)
            {
                for each (var encodedObject:* in proxy)
                {
                    for(var encodedObjectProperty:* in encodedObject.object_proxy::object)
                    {
                        try
                        {
                            var encodedObjectProxy:ObjectProxy = encodedObject[encodedObjectProperty];
                            xmlObject[encodedObjectProperty] = encodedObjectProxy.object_proxy::object;
                        }
                        catch(e:Error)
                        {
                            xmlObject[encodedObjectProperty] = encodedObject[encodedObjectProperty];
                        }
                    }
                }
            }
            
            
            
            
            return xmlObject;
        }
        
        public static function objectToJSON(obj:Object):String{
            try{
                return jsonEncoder.encode(obj);
            }
            catch(e:Error)
            {
            }
            return null;
        }
        
        
        public static function JSONToObject(json:String):Object{
            try{
                return jsonDecode(json);
            }
            catch(e:Error)
            {
				trace(e);
            }
            return null;
        }
        
        
        public static function saveXMLToFile(toSave:XML, outFile:File):void
        {
            
            
            const hide:Boolean = outFile.name.charAt(0) == ".";
            
            
            const outStream:FileStream = new FileStream();
            
            if(outFile){
                outStream.open(outFile, FileMode.WRITE);
                outStream.writeUTFBytes('<? xml version="1.0" ?>\n');
                outStream.writeUTFBytes(toSave.toXMLString());
            }
            
            outStream.close();
            
            if(hide){
                hideFile(outFile);
            }
            
            
            
        }
        
        public static function getXMLFromFile(file:File):XML{
            
            
            
            const stream:FileStream = new FileStream();
            var fileXML:XML;
            
            try{
                stream.open(file, FileMode.READ);
                fileXML = new XML(stream.readUTFBytes(stream.bytesAvailable));
            }catch(e:Error){
                
            }finally{
                stream.close();    
            }
            
            
            
            return fileXML;
        }
        
     
        
        private static function hideFile(outFile:File):void
        {
            if(!outFile || !outFile.exists){
                trace("File doesn't exist");
                return
            }
			
            if(!NativeProcess.isSupported)
            {
                trace("Cannot hide files due to native process not being supported");
                return;
            }
            else
            {
                const process:NativeProcess = new NativeProcess();
                var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
                var file:File = new File("C:\Windows\System32\attrib.exe");
                nativeProcessStartupInfo.executable = file;
                
                var processArgs:Vector.<String> = new Vector.<String>();
                processArgs[0] = "+h "+outFile.nativePath;
                nativeProcessStartupInfo.arguments = processArgs;
                
                
                process.start(nativeProcessStartupInfo);
                
            }
            
        }        
        
        
        
        
    }
}