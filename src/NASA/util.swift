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
