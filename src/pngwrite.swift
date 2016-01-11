import CPNG
import Glibc


func WritePNG(data:[Int16], size:Int, count:Int, A:Point, B:Point){
	let IFH = fopen("/media/sf_source/MOB/Work/Firestack/OUT.png", "wb")
	var png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, nil, nil, nil);
	var info_ptr = png_create_info_struct(png_ptr);


	let width:UInt = UInt((A-B).x)
	let height:UInt = UInt((A-B).y)
	let color_type = PNG_COLOR_TYPE_GRAY
	let bit_depth:Int32 = 16

	// Figure out how to convert data to row pointers
	//png_bytep * row_pointers;
	var row_pointers:[[UInt8]] = []
	// for r in 0..<(width){
	// 	row_pointers.append([])
	// 	for h in 0..<(height-1){
	// 		print(UInt8( truncatingBitPattern: data[ Int( r + (width-1) * h ) ] ))
	// 		//row_pointers[Int(r)].append( UInt8( truncatingBitPattern: data[ Int( r * width + h ) ] ) )
	// 	}
	// }

	for column in 0..<height{
		row_pointers.append([])
		for row in 0..<width{
			//print(UInt8( truncatingBitPattern: data[ Int( column*width + row ) ] ))
		}
	}




	png_init_io(png_ptr, IFH);


	/* write header */


	png_set_IHDR(png_ptr, info_ptr, width, height,
				 bit_depth, color_type, PNG_INTERLACE_NONE,
				 PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);


	png_write_info(png_ptr, info_ptr);


	/* write bytes */


	//png_write_image(png_ptr, &row_pointers);
	for i in 0..<width{
		png_write_row(png_ptr, UnsafeMutablePointer<UInt8>(row_pointers[Int(i)]))
	}


	/* end write */


	png_write_end(png_ptr, nil);
	//png_write_png (png_ptr, info_ptr, PNG_TRANSFORM_IDENTITY, nil)

	/* cleanup heap allocation */
	png_destroy_write_struct(&png_ptr, &info_ptr)


	fclose(IFH);
	print(PNG_LIBPNG_VER_STRING)
}
