//
//  File 2.swift
//  
//
//  Created by Ben Spratling on 5/17/20.
//

import Foundation
import SwiftPatterns
import SwiftCSS



public class UseElement : SVGChild {
	
	public init(xmlItem:XMLItem) {
		defId = xmlItem.attributes["href"] ?? xmlItem.attributes["xlink:href"]
		x = xmlItem.attributes["x"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		y = xmlItem.attributes["y"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		width = xmlItem.attributes["width"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		height = xmlItem.attributes["height"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		
		//TODO: write me
	}
	
	public init(defId:String?, x:SwiftCSS.Dimension?, y:SwiftCSS.Dimension?, width:SwiftCSS.Dimension?, height:SwiftCSS.Dimension?) {
		self.defId = defId
		self.x = x
		self.y = y
		self.width = width
		self.height = height
	}
	
	public var defId:String?
	
	public var xmlItem:XMLItem  {
		//TODO: keep up to par with the init(xmlItem...) method
		var attributes:[String:String] = [:]
		attributes["href"] = defId
		attributes["xlink:href"] = defId
		attributes["x"] = x?.cssString
		attributes["y"] = y?.cssString
		attributes["width"] = width?.cssString
		attributes["height"] = height?.cssString
		return XMLItem(name: "use", attributes: attributes, children: [])
	}
	
	public var id:String?
	
	public var x:SwiftCSS.Dimension?
	public var y:SwiftCSS.Dimension?
	public var width:SwiftCSS.Dimension?
	public var height:SwiftCSS.Dimension?
	
	//TODO: style, class, additional attributes, etc...
	
	
	public var deepCopy:SVGChild? {
		return UseElement(xmlItem:xmlItem)
	}
}
