import Foundation
#if os(Linux)
import Glibc
#endif

public class FileUtil{

	public static func GetRecursiveFiles( fromPath:String ) -> [String]?{
		#if os(OSX)

		let FS = NSFileManager()

		if let FSEnum = FS.enumeratorAtPath(fromPath){
			var files = [String]()
			for file in FSEnum{
				files.append(file as String)
			}
			return files
		}

		#elseif os(Linux)

		var files = [String]()
		for file in Glob(pattern:fromPath + "/**/*"){
			files.append(file)
		}
		return files

		#else

		let FS = NSFileManager()
		return FS.subpathsOfDirectoryAtPath(fromPath)

		#endif
	}

	public static func GetRecursiveFiles() -> [String]?{
		if let rootPath = NASA.rootStore {
			return GetRecursiveFiles(rootPath)
		}
		return nil
	}

	public static func FindFileFromPath(fileName:String) -> NSURL?{

		if let files = GetRecursiveFiles(){
			for file in files{
				if NSString(string:file).pathComponents.last == fileName.pathComponents.last{
					#if os(OSX)

					print(NASA.rootStore! + (file as! String))
					return NSURL(fileURLWithPath: NASA.rootStore! + "/" + (file as! String))

					#elseif os(Linux)

					print(file)
					return NSURL(fileURLWithPath: file)

					#endif
				}
			}
		}
		return nil
	}
}
