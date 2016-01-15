import Glibc

func WriteR16(data:[Int16], size:Int, count:Int){
	let IFH = fopen("/media/sf_source/MOB/Work/Firestack/OUT.r16", "wb")
	fwrite(UnsafePointer<Void>(data), size, count, IFH)
	fclose(IFH)
}
