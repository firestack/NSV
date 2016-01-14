//
//  indexreader.swift
//  NSVX
//
//  Created by Firestack on 1/14/16.
//  Copyright © 2016 stackfire. All rights reserved.
//

import Foundation


internal class FileUtil{
	static func FindFileFromPath(pathStart:String, fileName:String) -> NSURL?{
		let FS = NSFileManager()

		if let contents = FS.enumeratorAtPath(pathStart){
			for i in contents{
				
				if i.pathComponents?.last == fileName {
					print(pathStart + (i as! String))
					return NSURL(fileURLWithPath: pathStart + "/" + (i as! String))
				}
			}
		}
		return nil
	}
}

public class Index{
	private let INDEX:NSURL?
	private var fin:NSFileHandle?
	public var rows = NSMutableArray()
	
	static public func FindIndex(findFromPath:String) -> NSURL? {
		return FileUtil.FindFileFromPath(findFromPath, fileName:"index.tab")
	}
	
	init(pathRoot:String){
		INDEX = Index.FindIndex(pathRoot)
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
			guard line.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 5 else{
				continue
			}
			
			rows.addObject(line.componentsSeparatedByString(","))

		}
	}
	
	var isOpen:Bool { get { return ( fin != nil ? true : false ) } }
	
	public func query(col:Int, match:String) -> ([String], [[String]])? {
		guard isOpen else{
			return nil
		}
		
		var q = [String]()
		var qq = [[String]]()
		
		for row in rows{
			let crow = row[col] as! String
			if crow == match{
				q.append((row as! [String]).joinWithSeparator(" , "))
				qq.append(row as! [String])
			}
		}
		
		return (q, qq)
	}
	
}


