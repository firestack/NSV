import Foundation

public class Point: CustomStringConvertible{
	public var x:UInt64 = 0
	public var y:UInt64 = 0

	public init(_ x:UInt64, _ y:UInt64){
		self.x = x
		self.y = y
	}

	public init(pointTuple:(Int, Int)){
		self.x = UInt64(pointTuple.0)
		self.y = UInt64(pointTuple.1)
	}

	public var description: String { get {return "X:\(x) Y:\(y)"}}
}

infix operator - {associativity left precedence 140}
public func -(this:Point, that:Point) -> Point{
	return Point(this.x - that.x, this.y - that.y)
}

infix operator * {associativity left precedence 150}
public func *(this:Point, that:Point) -> Int{
	let length = (Int(that.x) - Int(this.x))
	let height = (Int(that.y) - Int(this.y))
	return length * height
}
