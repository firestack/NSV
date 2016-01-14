import Foundation
#if os(OSX)
import Darwin
#else
import Glibc
#endif


public class Point: CustomStringConvertible{
	public var x:UInt64 = 0
	public var y:UInt64 = 0

	init(_ x:UInt64, _ y:UInt64){
		self.x = x
		self.y = y
	}

	public var description: String { get {return "X:\(x) Y:\(y)"}}
}

public class LabelReader{
	let IFH:NSFileHandle? = nil

	public var LabelFile:String = ""

	init(FileName:String){
		LabelFile = FileName
	}

	public func read(){
		print("Reading From: \(LabelFile)...")


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
infix operator - {associativity left precedence 140}
public func -(this:Point, that:Point) -> Point{
	return Point(that.x - this.x, that.y - this.y)
}

infix operator * {associativity left precedence 140}
public func *(this:Point, that:Point) -> Int{
	let length = (Int(that.x) - Int(this.x))
	let height = (Int(that.y) - Int(this.y))
	return length * height
}


public class Map{
    var _largest:Int64 = -0xFFFFFFFF, _smallest:Int64 = 0xFFFFFFFF, _count:Int64 = 0x0, _sum:Int64 = 0x0;
    public var largest:Int64 {
        get {
            return _largest
        }
        set(value){
            if (value > _largest){
                _largest = value
            }
        }
    }
	public var smallest:Int64 {
		get {
			return _smallest
		}
		set(value){
			if (value < _smallest){
				_smallest = value
			}
		}
	}
	public var average:Int64 {
		get{
			return _sum / _count
		}
	}

	public func addSum(value:Int){
		_count += 1
		_sum += value
	}

	public func submit(value:Int16){
		largest = Int64(value)
		smallest = Int64(value)
		addSum(Int(value))
	}
	public func info(){
		print("\nLargest: \(largest)\tSmallest: \(smallest)\tAverage: \(average)")
	}
}


func WriteR16(data:[Int16], size:Int, count:Int){
	let IFH = fopen("/media/sf_source/MOB/Work/Firestack/OUT.r16", "wb")
	fwrite(UnsafePointer<Void>(data), size, count, IFH)
	fclose(IFH)
}



func main(){
	print("PROG_NAME = \(Process.arguments[0])")
	print("ARGC = \(Process.argc)")
	print("ARGV = \(Process.arguments)")
	let x = Point(0, 0)
	let y = Point(720, 1440)
	
	let NASA = Index(pathRoot:Process.arguments[1])
	print(NASA.query(3, match: "\"MEDIAN_TOPOGRAPHY\"")?.1.count)
	
	//let A = Surface(Process.arguments[1], 720, 1440)
	//let B = A.read(x, y )
	print(x-y)
	//±±==print(B.count)

	
    
	print(x*y)

	//WriteR16(B, size:2, count:x*y)
    
    
    //WritePNG(B, size:2, count:x*y, A:x, B:y)
	//
	// var file = "megt90n000cb.img"
	// if (Process.argc > 1){
	// 	file = Process.arguments[1]
	// }
	//
	// let FH = NSFileHandle(forReadingAtPath:file)
	// let mapping = Map()
	// if let data = FH?.readDataOfLength((1440*2) * 720/*(read all lines) 16bits per interger*/){
	//     let line = UnsafePointer<Int16>(data.bytes)
	//     for idx in 0..<data.length/2{
	//
	//         var ending = "\t"
	//
	//         if (idx % 8 == 0){
	//             ending = "\n"
	//         }
	// 		mapping.submit(line[idx].bigEndian)
	//         print(line[idx].bigEndian, terminator:ending)
	//
	//     }
	//
	// }
	// mapping.info()
}
