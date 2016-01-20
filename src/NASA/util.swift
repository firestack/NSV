import Foundation

#if os(Linux)
import Glibc
#endif

public func stripChars(str:String) -> String {
	return str.stringByTrimmingCharactersInSet(NSMutableCharacterSet(charactersInString:"\"")).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
}

public class NASA{
	static public var rootStore:String?
	static public var MGSL:Index?

	static public func initalize(root:String){
		rootStore = root
		MGSL = Index(pathRoot:root)
	}

	static public var description:String{
		get{
			return "Root: \(rootStore)"

		}
	}
}


public func writeToFile(name:String, inout _ data:[Int16]) -> Bool{
	let FS = NSFileManager()
	let size = data.count * sizeofValue(data[0])
	print("The size of the array is \(size)\nAttempting to write to \(name)")
	let d = NSData(bytes:data, length:size)
	if FS.createFileAtPath(name, contents:nil, attributes:nil){
		if let fout = NSFileHandle(forWritingAtPath:name){
			fout.writeData(d)
			return true

		}
		return false

	}
	else{
		return false
	}

}
