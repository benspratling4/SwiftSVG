//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/16/20.
//

import Foundation
import SwiftPatterns



extension XMLItem {
	///exporting an XMLItem to a string
	public var string:String {
		var buffer = "<\(name ?? "")"
		for (key, value) in attributes {
			buffer += " \(key)=\"\(value)\""
		}
		if children.count == 0 {
			buffer += "/>"
			return buffer
		}
		buffer += ">"
		for child in children {
			if let xmlItemChild = child as? XMLItem {
				buffer += xmlItemChild.string
			} else if let stringChild = child as? String  {
				buffer += stringChild
			}
		}
		buffer += "</\(name ?? "")>"
		
		return buffer
	}
	
}
