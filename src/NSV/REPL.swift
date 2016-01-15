import Foundation
import NASA

func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)!.bridge()
}

class Lookup{
	static var Functions:Dictionary<String, (String)->()> = [
		"test":{(String) -> () in print("Hello world!!")},
		"getImage":{ (m:String) -> () in
			print(m)
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
			function(message)
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
