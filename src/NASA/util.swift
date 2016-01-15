import Foundation

#if os(Linux)
import Glibc
#endif

func stripChars(str:String) -> String {
	return str.stringByTrimmingCharactersInSet(NSMutableCharacterSet(charactersInString:"\"")).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
}

public class NASA{
	static public var rootStore:String = ""
}

public class FileUtil{
	public static func FindFileFromPath(pathStart:String, fileName:String) -> NSURL?{

		let FS = NSFileManager()

		#if os(OSX)

		if let contents = FS.enumeratorAtPath(pathStart){
			for file in contents{

				if NSString(string:file as! String).pathComponents.last == fileName {
					print(pathStart + (file as! String))
					return NSURL(fileURLWithPath: pathStart + "/" + (file as! String))
				}
			}
		}

		#elseif os(Linux)



		for file in Glob(pattern:pathStart + "/**/*"){
			if NSString(string:file).pathComponents.last == fileName {
				print(file)
				return NSURL(fileURLWithPath: file)
			}
		}

		#else

		if let files = try? FS.subpathsOfDirectoryAtPath(pathStart){
		for file in files{
			//print(file)
			if NSString(string:file).pathComponents.last == fileName {
				print(pathStart + "/" + (file))
				return NSURL(fileURLWithPath: pathStart + "/" + (file))
			}
		}}

		#endif
		return nil
	}
}
