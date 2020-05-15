//
//  File 2.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation
import SwiftGraphicsCore
import SwiftCSS

public enum PathElementError:Error {
	case missingRequiredAttribute(String)
}


public class PathElement : HTMLXMLNode {
	/*
	public init(path:Path, fillColor:SampledColor) {
		var style:String = ""
		if fillColor.components.count == 3 {
			style = "fill:" + CSSColor.rgb(fillColor.components[0][0], fillColor.components[1][0], fillColor.components[2][0]).cssString
		} else if fillColor.components.count == 4 {
			style = "fill:" + CSSColor.rgba(fillColor.components[0][0], fillColor.components[1][0], fillColor.components[2][0], fillColor.components[3][0]).cssString
		}
		
		super.init(name: "path", attributes: ["d":path.svg_d,
											  "style":style
		], children: [])
	}
	
	public init(path:Path, color:SampledColor, lineWidth:SGFloat) {
		var style:String = ""
		if fillColor.components.count == 3 {
			style = "stroke:" + CSSColor.rgb(fillColor.components[0][0], fillColor.components[1][0], fillColor.components[2][0]).cssString
		} else if fillColor.components.count == 4 {
			style = "stroke:" + CSSColor.rgba(fillColor.components[0][0], fillColor.components[1][0], fillColor.components[2][0], fillColor.components[3][0]).cssString
		}
		//TODO: color attribute
		//TODO: write me
		super.init(name: "path", attributes: ["d":path.svg_d,
											  "style":style,
											  "stroke-width":"\(lineWidth)"
		], children: [])
	}
	*/
}

extension Path {
	var svg_d:String {
		var string:String = ""
		for subPath in self.subPaths {
			for element in subPath.segments {
				switch element.shape {
				case .point:
					string += "M\(element.end.x),\(element.end.y)"
				case .line:
					string += "L\(element.end.x),\(element.end.y)"
				case .quadratic(let control):
					string += "Q\(control.x),\(control.y),\(element.end.x),\(element.end.y)"
				case .cubic(let control0, let control1):
					string += "C\(control0.x),\(control0.y),\(control1.x),\(control1.y),\(element.end.x),\(element.end.y)"
					//TODO: add support to SwiftGraphicsCore for explicit closing paths
					//TODO: add support to SwiftGraphicsCore for arcs
				}
			}
		}
		return string
	}
}



/*
public struct PathElement : SVGXMLItem {
	
	public var d:String
	
	public var strokeColor:CSSColor?
	
	public var fillColor:CSSColor?
	
	//stroke-width
	
	
	
	//SVGXMLItem
	
	public init(xmlItem:XMLItem)throws {
		guard let d = xmlItem.attributes["d"] else {
			throw PathElementError.missingRequiredAttribute("d")
		}
		self.d = d
		strokeColor = xmlItem.attributes["stroke"].flatMap({ Scanner(string: $0).scanCssColor() })
		fillColor = xmlItem.attributes["fill"].flatMap({ Scanner(string: $0).scanCssColor() })
		//TODO: stroke-width
	}
	
	public var xml:XMLItem {
		var attributes:[String:String] = [:]
		attributes["stroke"] = strokeColor?.valueString
		attributes["fill"] = fillColor?.valueString
		//TODO: stroke width
		return XMLItem(name:"path", attributes:, children:[])
	}
	
}
*/
