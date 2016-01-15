import Foundation

public class labelInfo {
	public init(location:NSURL){

	}
}


public class imageProxy{
	let FS:NSFileHandle?


	public init(path:NSURL){
		FS = try? NSFileHandle(forReadingFromURL:path)

	}
}

public class Surface{
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
