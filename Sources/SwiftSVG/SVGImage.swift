//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/15/20.
//

import Foundation
import SwiftPatterns
import SwiftGraphicsCore
import SwiftCSS

///Root of an SVG graphic
public class SVGImage {
	
	public init(size:Size, preserveAspectRatio:AspectRatioPreservation = .default) {
		viewBox = Rect(origin: .zero, size: size)
		self.preserveAspectRatio = preserveAspectRatio
	}
	
	
	public var viewBox:Rect
	public var preserveAspectRatio:AspectRatioPreservation
	
	var defs:[Any] = []	//FIXME: refine the type
	var style:[Declaration] = []
	
	
	
	public init(xmlItem:XMLItem)throws {
		if let viewBoxAttribute:String = xmlItem.attributes["viewBox"] {
			let scanner:Scanner = Scanner(string: viewBoxAttribute)
			let doubles:[Double] = scanner.scanDoublesUntilNoLongerScanable()
			if doubles.count >= 4 {
				viewBox = Rect(origin: Point(x: doubles[0], y: doubles[1]), size: Size(width: doubles[2], height: doubles[3]))
			} else {
				viewBox = Rect(origin: .zero, size: Size(width: 100.0, height: 100.0))
			}
		} else {
			viewBox = Rect(origin: .zero, size: Size(width: 100.0, height: 100.0))	//not right, but will do for now
		}
		preserveAspectRatio = xmlItem.attributes["preserveAspectRatio"].flatMap({ AspectRatioPreservation(string:$0) }) ?? .default
		
		//TODO: write me
		
		
		//FIXME: if viewBox was not provided directly, create it by finding the bounding box of all internal elements
	}
	
	
	public var xmlItem:XMLItem {
		return XMLItem(name: "svg"
			,attributes: [
				"xmlns" : "http://www.w3.org/2000/svg",
				"viewBox" : "\(viewBox.origin.x) \(viewBox.origin.y) \(viewBox.size.width) \(viewBox.size.height)",
				"preserveAspectRatio" : preserveAspectRatio.xmlAttribute
			]
			
			,children: [])
		
	}
	
	
	
}



