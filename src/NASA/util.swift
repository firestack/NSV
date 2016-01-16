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


public func writeToFile(name:String,_ data:[Int16]) -> Bool{
	let FS = NSFileManager()
	let size = data.count * sizeofValue(data)
	print("The size of the array is \(size)\nAttempting to write to \(NASA.rootStore!+name)")
	return FS.createFileAtPath(NASA.rootStore!+name, contents:NSData(bytes:data, length:size), attributes:nil)
}
