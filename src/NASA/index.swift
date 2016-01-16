//
//  indexreader.swift
//  NSVX
//
//  Created by Firestack on 1/14/16.
//  Copyright © 2016 stackfire. All rights reserved.
//

import Foundation


public class Index{
	private let INDEX:NSURL?
	private var fin:NSFileHandle?
	public var rows = [[String]]()

	static public func FindIndex() -> NSURL? {
		return FileUtil.FindFileFromPath("index.tab")
	}

	public init(pathRoot:String){
		INDEX = Index.FindIndex()
		openIndex()
		preOpen()

	}

	func openIndex(){
		guard let INDEX = INDEX else {
			return
		}

		fin = NSFileHandle(forReadingAtPath: INDEX.path!)


	}

	func preOpen(){
		guard isOpen else{
			return
		}

		let rowString = NSString(data: fin!.readDataToEndOfFile(), encoding: NSASCIIStringEncoding)
		for line in rowString!.componentsSeparatedByString("\n"){
			guard NSString(string:line).lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 5 else{
				continue
			}

			#if os(OSX)
			//rows.addObject(NSString(string:line).componentsSeparatedByString(","))
			rows.append(NSString(string:line).componentsSeparatedByString(","))
			#else
			//rows.addObject(NSString(string:line).componentsSeparatedByString(",").bridge())
			//stringByTrimmingCharactersInSet(NSMutableCharacterSet(charactersInString:"\"")).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

			rows.append(NSString(string:line).componentsSeparatedByString(",").map(stripChars))
			#endif

		}
	}

	var isOpen:Bool { get { return ( fin != nil ? true : false ) } }

	public func query(searchParams:[SearchQuery]) -> [FileCat]? {
		guard isOpen else{
			return nil
		}

		// var q = [String]()
		// var qq = [[String]]()
		var search = [FileCat]()

		for row in rows{
			var results = [Bool]()
			for searchParam in searchParams{
				results.append(searchParam.test(row))
			}

			if (results.reduce(true) { return $0 && $1 } ) == true {
				#if os(OSX)

				// q.append((row as! [String]).joinWithSeparator(" , "))
				// qq.append(row as! [String])
				search.append(FileCat(data:row))

				#else

				// q.append((row).joinWithSeparator(" , "))
				// qq.append(row)
				search.append(FileCat(data:row))

				#endif
			}


		}

		return search
	}

}
