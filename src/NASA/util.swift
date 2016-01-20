import Foundation

#if os(Linux)
import Glibc
#elseif os(OSX)
import Darwin
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

extension Array{
	public func writeToFile(path:String) -> Bool {
		// Get File Manager
		let FS = NSFileManager()

		if FS.fileExistsAtPath(path.stringByDeletingLastPathComponent, isDirectory:nil){
			do {
				try FS.createDirectoryAtPath(path.stringByDeletingLastPathComponent, withIntermediateDirectories:true, attributes:nil)

			}
			catch _ {
				return false
			}
		}
		return FS.createFileAtPath(path, contents:NSData(bytes:self, length: self.count * sizeofValue(self[0])), attributes:nil)
	}

	public func tileToFiles(path:String = "./tiles/", fileprefix:String = "tile", subdivisions:UInt = 0 , size:Point) -> Bool{
		let FS = NSFileManager()
		// Create Directory
		if FS.fileExistsAtPath(path, isDirectory:nil){
			do {
				try FS.createDirectoryAtPath(path, withIntermediateDirectories:true, attributes:nil)

			}
			catch _ {
				return false
			}
		}
		// Subdivide data

		let totalTiles = UInt(pow(4.0, Double(subdivisions)))
		let edgeTiles = UInt(pow(2.0, Double(subdivisions)))

		guard totalTiles == edgeTiles * edgeTiles else{
			print("NOT MATCHING MATH INCORECT")
			return false
		}

		let tileSize = size / edgeTiles

		print("\(totalTiles) tiles with a tile size of \(tileSize)")

		for tileRow in (0..<edgeTiles){
			for tileColumn in (0..<edgeTiles){
				var tileData = [Element]()
				// Lets run our {pointers,fingers} though this array (hehe)
				for y in ((tileSize.y * UInt64(tileRow))..<((tileSize.y * UInt64(tileRow)) + tileSize.y)){
					//let tileXYStart = (y * size.x) + (UInt64(tileRow) * tileSize.x)
					let tileXYStart = (y * size.x) + ( tileSize.x * UInt64(tileColumn))
					let tileXYEnd   = (y * size.x) + ( tileSize.x * UInt64(tileColumn)) + tileSize.x

					tileData.appendContentsOf(self[Int(tileXYStart)..<Int(tileXYEnd)])

					//
					// for x in ((tileSize.x * UInt64(tileColumn))..<((tileSize.x * UInt64(tileColumn)) + tileSize.x)){
					// 	// Single dimentional to multidimentional accessor
					// 	tileData.append( self[ (y * size.x) + x ] )
					// }

				}
				let pathAndFileNameString = "\(path)/\(fileprefix)_X\(tileColumn)_Y\(tileRow).r16"
				print("writing '\(pathAndFileNameString)'")
				FS.createFileAtPath(
					pathAndFileNameString,
					contents: NSData(bytes:tileData, length:tileData.count * sizeofValue(tileData[0])),
					attributes:nil
				)
			}
		}

		return true

	}
}

public func writeToFile(path:String, inout _ data:[Int16]) -> Bool{
	let FS = NSFileManager()
	let size = data.count * sizeofValue(data[0])
	print("The size of the array is \(size)\nAttempting to write to \(path)")
	let d = NSData(bytes:data, length:size)
	if FS.createFileAtPath(path, contents:nil, attributes:nil){
		if let fout = NSFileHandle(forWritingAtPath:path){
			fout.writeData(d)
			return true

		}
		return false

	}
	else{
		return false
	}

}
