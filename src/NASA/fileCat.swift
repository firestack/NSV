
import Foundation

public class FileCat: CustomStringConvertible{
	var internalData:[String]

	init(data:[String]){
		internalData = data
	}

	public var description:String {
		get {
			return "\n" +
			"volumeID: \(volumeID)\n" +
			"file specification name: \(fileSpecificationName)\n"  +
			"product ID: \(productID)\n"  +
			"map type: \(mapType)\n"  +
			"map resolution: \(mapResolution)\n"  +
			"map scale: \(mapScale)\n"  +
			"lines: \(lines)\n"  +
			"line samples: \(lineSamples)\n"  +
			"bits: \(sampleBits)\n"  +
			"\n"
		}
	}

	public var volumeID:String {
		get{
			return internalData[0]
		}
	}
	public var fileSpecificationName:String {
		get{
			return internalData[1]
		}
	}
	public var productID:String {
		get{
			return internalData[2]
		}
	}
	public var mapType:String {
		get{
			return internalData[3]
		}
	}
	public var productVersionID:String {
		get{
			return internalData[4]
		}
	}
	public var productCreationTime:String {
		get{
			return internalData[5]
		}
	}
	public var maximumLatitude:String {
		get{
			return internalData[6]
		}
	}
	public var minumumLatitude:String {
		get{
			return internalData[7]
		}
	}
	public var westernmostLongitude:String {
		get{
			return internalData[8]
		}
	}
	public var easternmostLongitude:String {
		get{
			return internalData[9]
		}
	}
	public var mapResolution:String {
		get{
			return internalData[10]
		}
	}
	public var mapScale:String {
		get{
			return internalData[11]
		}
	}
	public var lines:String {
		get{
			return internalData[12]
		}
	}
	public var lineSamples:String {
		get{
			return internalData[13]
		}
	}
	public var sampleBits:String {
		get{
			return internalData[14]
		}
	}
}

extension FileCat: Equatable {}

public func ==(lhs: FileCat, rhs: FileCat) -> Bool{
	guard lhs.internalData.count == rhs.internalData.count else{
		return false
	}

	for i in 0..<lhs.internalData.count{
		if lhs.internalData[i] != rhs.internalData[i]{
			return false
		}
	}

	return true
}
