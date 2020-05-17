//
//  GroupElement.swift
//  
//
//  Created by Ben Spratling on 5/17/20.
//

import Foundation
import SwiftPatterns
import SwiftGraphicsCore
import SwiftCSS


public class GroupElement : SVGChild, SVGChildContainer {
	
	public var id:String?
	public var classes:[String] = []
	public var style:[Declaration] = []
	
	public var x:SwiftCSS.Dimension?
	public var y:SwiftCSS.Dimension?
	public var width:SwiftCSS.Dimension?
	public var height:SwiftCSS.Dimension?
	public var transforms:[SVGTransform]
	public var children:[SVGChild] = []
	
	public init?(xmlItem:XMLItem) {
		self.id = xmlItem.attributes["id"]
		self.classes = xmlItem.attributes["class"]?.components(separatedBy:" ") ?? []
		
		style = xmlItem.attributes["style"].flatMap({ [Declaration](inlineStyle: $0) }) ?? []
		
		x = xmlItem.attributes["x"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		y = xmlItem.attributes["y"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		width = xmlItem.attributes["width"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		height = xmlItem.attributes["height"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		
		transforms = xmlItem.attributes["transform"].flatMap({Scanner(string: $0).scanSVGTransform()}) ?? []
		
		
		let childFactory:SVGChildFactory = SVGChildFactory()
		children = xmlItem.children
			.compactMap({ $0 as? XMLItem })
			.compactMap(childFactory.child(xmlItem:))
	}
	
	public var xmlItem:XMLItem {
		var additionalAttributes:[String:String] = [:]
		if let id:String = self.id {
			additionalAttributes["id"] = id
		}
		additionalAttributes["x"] = x?.cssString
		additionalAttributes["y"] = y?.cssString
		additionalAttributes["width"] = width?.cssString
		additionalAttributes["height"] = height?.cssString
		if classes.count > 0 {
			let classString:String = classes.joined(separator: " ") 
			additionalAttributes["class"] = classString
		}
		
		additionalAttributes["transform"] = transforms.count > 0 ? transforms.svgString : nil
		return XMLItem(name: "g", attributes:additionalAttributes, children: children.map({ $0.xmlItem }))
	}
	
	
	public var deepCopy:SVGChild? {
		return GroupElement(xmlItem: xmlItem)
	}
	
}



extension GroupElement : DrawableChild {
	public func draw(in context:GraphicsContext) {
		
		
		//TODO: write me
	}
	
	public var boundingBox:Rect {
		var childBoundingBoxes:[Rect] = children.compactMap({ $0 as? DrawableChild}).map({ $0.boundingBox })
		if childBoundingBoxes.count == 0 { return Rect(origin: .zero, size: .zero) }
		let firstBox = childBoundingBoxes.removeFirst()
		return childBoundingBoxes.reduce(firstBox, { $0.unioning($1) })
	}
	
}

