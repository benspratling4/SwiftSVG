//
//  File 2.swift
//  
//
//  Created by Ben Spratling on 5/7/20.
//

import Foundation
import SwiftPatterns
import SwiftGraphicsCore
import SwiftCSS

public enum PathElementError:Error {
	case missingRequiredAttribute(String)
}


public class PathElement : SVGChild {
	
	public init(path:Path, id:String? = nil, classes:[String] = []) {
		self.path = path
		self.id = id
		self.classes = classes
		transforms = []
	}
	
	public var path:Path
	public var id:String?
	public var classes:[String] = []
	public var fillShader:Shader?
	public var strokeShader:Shader?
	public var strokeWidth:SwiftCSS.Dimension?
	public var fillDefId:String?	//if the fill is a url(#____) instead
	public var strokeDefId:String?	//if the fill is a url(#____) instead
	
	public var style:[Declaration] = []
	
	public var x:SwiftCSS.Dimension?
	public var y:SwiftCSS.Dimension?
	public var width:SwiftCSS.Dimension?
	public var height:SwiftCSS.Dimension?
	
	//if x or y is also specified, they are applied after this transform
	public var transforms:[SVGTransform]
	
	public init?(xmlItem:XMLItem) {
		guard let d:String = xmlItem.attributes["d"]
			,let path:Path = try? Path(svg_d: d)
			else {
			return nil
		}
		self.path = path
		self.id = xmlItem.attributes["id"]
		self.classes = xmlItem.attributes["class"]?.components(separatedBy:" ") ?? []
		if let fillString = xmlItem.attributes["fill"] {
			let scanner:Scanner = Scanner(string: fillString)
			_ = try? scanner.scanCharactersInSet(.whitespacesAndNewlines)
			if let solidColor = scanner.scanCssColor() {
				fillShader = SolidColorShader(color: SampledColor(cssColor: solidColor))
			}
		}
		if let strokeString = xmlItem.attributes["stroke"] {
			let scanner:Scanner = Scanner(string: strokeString)
			_ = try? scanner.scanCharactersInSet(.whitespacesAndNewlines)
			if let solidColor = scanner.scanCssColor() {
				strokeShader = SolidColorShader(color: SampledColor(cssColor: solidColor))
			}
		}
		style = xmlItem.attributes["style"].flatMap({ [Declaration](inlineStyle: $0) }) ?? []
		
		if let strokeWidthString:String = style.filter({ $0.name == "stroke-width" }).last?.value {
			let scanner:Scanner = Scanner(string: strokeWidthString)
			if let (number, units) = scanner.scanDimesions() {
				strokeWidth = Dimension(number:number, unit:units)
			} else if let number:Float64 = scanner.scanDouble() {
				//assume pixels
				strokeWidth = Dimension(number:number, unit:AbsoluteLengthUnits.px)
			}
		}
		x = xmlItem.attributes["x"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		y = xmlItem.attributes["y"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		width = xmlItem.attributes["width"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		height = xmlItem.attributes["height"].flatMap({ Scanner(string: $0).scanLengthDimesions() }).flatMap({ SwiftCSS.Dimension(number: $0.0, unit: $0.1) })
		
		transforms = xmlItem.attributes["transform"].flatMap({Scanner(string: $0).scanSVGTransform()}) ?? []
		//if
		
		//find more things?
	}
	
	public var xmlItem:XMLItem {
		var additionalAttributes:[String:String] = ["d":path.svg_d]
		if let id:String = self.id {
			additionalAttributes["id"] = id
		}
		additionalAttributes["x"] = x?.cssString
		additionalAttributes["y"] = y?.cssString
		additionalAttributes["width"] = width?.cssString
		additionalAttributes["height"] = height?.cssString
		if classes.count > 0
			,let classString:String = classes.joined(separator: " ") {
			additionalAttributes["class"] = classString
		}
		if let solidShader:SolidColorShader = fillShader as? SolidColorShader
			,let cssColor:CSSColor = solidShader.color.cssColor {
			additionalAttributes["fill"] = cssColor.cssString
		} else if let fillDef:String = fillDefId {
			additionalAttributes["fill"] = "url(#\(fillDef))"
		}
		if let solidShader:SolidColorShader = strokeShader as? SolidColorShader
			,let cssColor:CSSColor = solidShader.color.cssColor {
			additionalAttributes["stroke"] = cssColor.cssString
		} else if let strokeDef:String = strokeDefId {
			additionalAttributes["stroke"] = "url(#\(strokeDef))"
		}
		if let width = strokeWidth {
			additionalAttributes["stroke-width"] = width.cssString
		}
		additionalAttributes["transform"] = transforms.count > 0 ? transforms.svgString : nil
		
		return XMLItem(name: "path", attributes:additionalAttributes, children: [])
	}
	
	
	public var deepCopy:SVGChild? {
		return PathElement(xmlItem: xmlItem)
	}
	
}


extension PathElement : DrawableChild {
	
	public func draw(in context: GraphicsContext) {
		//FIXME: resolve physical dimensions
		var stroke:(Shader, StrokeOptions)?
		if let strokeWidth:SGFloat = self.strokeWidth?.number
			,let strokeColor:Shader = self.strokeShader {
			stroke = (strokeColor, StrokeOptions(lineWidth: strokeWidth))
		}
		//if x, y are different, use those
		var transform:Transform2D = self.transforms.transform2D(center: boundingBox.center)
		if let x = self.x {
			//FIXME: resolve other units
			transform = transform.concatenate(with: Transform2D(translateX: x.number, y: 0.0))
		}
		if let y = self.y {
			//FIXME: resolve other units
			transform = transform.concatenate(with: Transform2D(translateX: 0.0, y: y.number))
		}
		
		context.drawPath(transform.transform(path), fillShader: fillShader, stroke: stroke)
	}
	
	public var boundingBox:Rect {
		//if x, y are different, use those
		var transform:Transform2D = .identity
		if let x = self.x {
			//FIXME: resolve other units
			transform = transform.concatenate(with: Transform2D(translateX: x.number, y: 0.0))
		}
		if let y = self.y {
			//FIXME: resolve other units
			transform = transform.concatenate(with: Transform2D(translateX: 0.0, y: y.number))
		}
		//FIXME: add line thickness
		return transform.transform(path).boundingBox ?? Rect(origin: .zero, size: .zero)
	}
	
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
