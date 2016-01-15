import Foundation

public class SearchQuery{
	public var row:Int
	public var match:String

	public init(_ row:Int,_ match:String){
		self.row = row
		self.match = match
	}

	public func test(rowData:[String]) -> Bool{
		return (rowData[row] == match)
	}
}
