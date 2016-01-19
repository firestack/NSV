import Foundation
import NASA

func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)!.bridge()
}

class Lookup{
	static var searchString = { (m:String) -> [FileCat]? in
		var requestParams = m.componentsSeparatedByString(" ")
		var searchParams = m.componentsSeparatedByString("||")
		searchParams = searchParams.map( stripChars )



		if searchParams.count >= 2{
			var SearchQueryRequest = [SearchQuery]()
			for searchParam in searchParams{

				var params = searchParam.componentsSeparatedByString(" ")

				if params.count == 2{
					if let col = Int(params[0]){
						SearchQueryRequest.append(SearchQuery(
							col,
							params[1]
						))
					}
				}
			}

			if let MGSL = NASA.MGSL where SearchQueryRequest.count != 0{

				return MGSL.query(SearchQueryRequest)

			}else{
				print("Something failed")
				if NASA.MGSL == nil{
					print("Not Initlized")
				}
			}
		}
		return nil;
	}

	static var Functions:Dictionary< String, (String) -> String? > = [
		"test":{(String) -> String? in
			print("Hello world!!")
			return nil
		},

		"getImage":{ (m:String) -> String? in
			return nil;
		},

		"query":{ (m:String) -> String? in
			var ret = searchString(m)
			if let optionReturn = ret{
				return String(optionReturn)
			}
			else{
				return nil
			}
		},

		"findimg":{ (m:String) -> String? in
			guard let bestMatch = searchString(m)?[0] else{
				return nil
			}
			var _ = labelInfo(fromFileCat:bestMatch)
			//print(FileUtil.FindFileFromPath(nil, fileName:bestMatch.productID.lowercaseString)?.path)
			return nil
		},

		"create": {(m:String) -> String? in
			guard let bestMatch = searchString(m)?[0] else{
				return nil
			}
			var labelRef = labelInfo(fromFileCat:bestMatch)
			print("Using the best match: \(bestMatch)")

			print("Enforcing size constraints on image\n X:0->\(bestMatch.lineSamples)\tY:0->\(bestMatch.lines)\nBit width \(bestMatch.sampleBits)")

			// Reuseable closure
			var GetNumber = { (message:String) -> (Int, Int) in
				print(message)
				// Get user input for first Point. Loop if larger than boundries
				var shouldExit = false
				repeat {
					var UI = readLine(stripNewline:true)!.componentsSeparatedByString(" ")

					guard UI.count >= 2 else{
						print("Must enter two numbers")
						continue
					}

					guard let x = Int(UI[0]), y = Int(UI[1]) else{
						print("Must be intergers")
						continue
					}

					guard 0 <= x && x < bestMatch.X &&
					0 <= y && y < bestMatch.Y else{
						print("Must be within range")
						continue
					}

					return (x, y)


				} while(!shouldExit)

			}

			var pos1 = Point(pointTuple:GetNumber("Point.1:"))
			var pos2 = Point(pointTuple:GetNumber("Point.2"))

			print("P1\(pos1) \nP2\(pos2) \nsize:\(pos2 - pos1) \narea:\(pos1 * pos2)")

			print("Name your file:", terminator:"")
			var block = labelRef.img!.getBlock(pos1, pos2)

			return String(writeToFile("./"+readLine(stripNewline:true)!+".r16", &block))
		},

		"init":{ (m:String) -> String? in
			var requestParams = m.componentsSeparatedByString(" ")
			if requestParams.count > 1{
				NASA.initalize(requestParams[1])
				return "Initlized from string"

			}else if Process.argc >= 2{

				NASA.initalize(Process.arguments[1])
				return "Initlized from process \(NASA.description)"

			}

			return "Failed"

		},
		"list":{ (m:String) -> String? in
			if let data = FileUtil.GetRecursiveFiles() {
				return data.reduce("") { return $0! + "\n" + $1 }
			}
			return nil
		},

		"testWrite":{ (m:String) -> String? in
			// Tutorial: how to write bytes to file in swift. :D
			// Create File
			var FS = NSFileManager()
			FS.createFileAtPath("./out.bin", contents:nil, attributes:nil)
			// Open file for writing
			var fout = NSFileHandle(forWritingAtPath:"./out.bin")
			// Create data
			var data = [1,2,3,4,5,6,7,8,9,7,8,6,6,46,54,654,654,654,651,654,6894,61,651]
			// Get the size in bytes of the data
			var size = data.count
			size *= sizeofValue(data)
			//Transform the data into NSData using "pointers" and the size obtained above
			fout?.writeData(NSData(bytes:data, length: size ))
			return String(size)
		},

		"testWriteAlt":{ (m:String) -> String? in
			// This works. simpler than above ("testWrite")
			var FS = NSFileManager()

			var data = [1,2,3,4,5,6,7,8,9,7,8,6,6,46,54,654,654,654,651,654,6894,61,651]
			var size = data.count
			size *= sizeofValue(data)

			return String(FS.createFileAtPath("./out.bin", contents:NSData(bytes:data, length:size), attributes:nil))

		}



	]
}

class REPL{
	var message:String = ""
	var returnMessage:String = ""
	var bRunning = true
	var lineNumber:Int = 0

	init(){}

	func read(){
		print("\(lineNumber)> ", terminator:"")
		message = readLine(stripNewline: true)!

	}

	func eval(){

		returnMessage = ""
		defer{
			returnMessage = "$R = " + returnMessage
		}
		if let function = Lookup.Functions[message.componentsSeparatedByString(" ")[0]]{
			if let rStr = function(message){
				returnMessage = rStr
			}else{
				returnMessage = "nil"
			}
		}
		else{
			// Internal commands
			switch (message){
				case ":q":
					bRunning = false

				default:
					returnMessage = message
			}
		}

	}

	func println(){
		if returnMessage != "" { print(returnMessage) }
	}

	func loop(){
		print(bRunning)
		repeat{
			read()
			eval()
			println()
			lineNumber += 1
		}while(bRunning)
	}
}
