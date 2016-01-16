import Foundation

public class SearchQuery{
	public var row:Int
	public var match:String
	var ref:FileCat?

	public init(_ row:Int,_ match:String){
		self.row = row
		self.match = match
		ref = nil
	}

	public init(compare:FileCat){
		ref = compare
		row = -1
		match = "*"
	}

	public func test(rowData:[String]) -> Bool{
		if let obj = ref{
			return (FileCat(data:rowData) == obj)
		}

		if match == "*"{

			return true
		}

		if row == -1 {
			for column in rowData{
				if column == match{
					return true
				}
			}
			return false
		}

		return (rowData[row] == match)
	}
}
