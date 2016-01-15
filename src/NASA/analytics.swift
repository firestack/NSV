
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
