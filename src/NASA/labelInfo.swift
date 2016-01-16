import Foundation

public class labelInfo: CustomStringConvertible{
	var URI:NSURL?
	public var img:imageProxy?
	var info:FileCat

	public init(fromFileCat:FileCat){
		info = fromFileCat
		URI = FileUtil.FindFileFromPath(info.fileSpecificationName.lowercaseString)
		createImageProxy()

		print(self)

	}

	public var description:String{
		get{

			return "URI Path: \(URI)\n\nInfo: \(info)\nImageRef \(img)"
		}
	}

	func createImageProxy(){
		if let location = FileUtil.FindFileFromPath(info.productID.lowercaseString){
			img = imageProxy(URI:location, fileCat:info)
		}
	}
}


public class imageProxy: CustomStringConvertible {
	let FS:NSFileHandle?
	let URI:NSURL
	let fileSpec:FileCat
	let stats = Map()

	public var description:String {
		get {
			return "\(URI.path)"
		}
	}

	public init(URI:NSURL, fileCat:FileCat){
		self.URI = URI
		FS = try? NSFileHandle(forReadingFromURL:URI)
		fileSpec = fileCat

	}

	public func getBlock(a:Point,_ b:Point) -> [Int16]{
		var imgBlock = [Int16]()

		for heightPos in a.y..<b.y{
			// Seek to line + offset * 2 because of Int16 width
			FS?.seekToFileOffset((heightPos * UInt64(fileSpec.X!) * 2) + (a.x * 2))

			if let data = FS?.readDataOfLength(Int((b-a).x * 2)){
				let line = UnsafePointer<Int16>(data.bytes)
				for idx in 0..<data.length/2{
					stats.submit(line[idx].bigEndian)
					imgBlock.append(line[idx].bigEndian)
				}
			}
		}

		return imgBlock
	}
}

public class Surface {
	var IFH:NSFileHandle? = nil

	var SX:UInt64 = 0
	var SY:UInt64 = 0
	var info = Map()


	init(_ FN: String, _ sizex:UInt64, _ sizey:UInt64){
		IFH = NSFileHandle(forReadingAtPath:FN)
		SX = sizex
		SY = sizey
	}

	public func read(a:Point, _ b:Point) -> [Int16]{
		var LData:[Int16] = []
		var total = 0

		for ypos in 0..<(a-b).y{
			IFH?.seekToFileOffset(ypos * (SX * 2))

			if let data = IFH?.readDataOfLength(Int((a-b).x * 2)){
				let line = UnsafePointer<Int16>(data.bytes)

				for idx in 0..<data.length/2{
					info.submit(line[idx].bigEndian)
					LData.append(line[idx].bigEndian)
					total += 1
				}
			}
		}
		info.info()
		return LData
	}



}
