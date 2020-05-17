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
public class SVGImage : SVGChildContainer {
	
	public init(size:Size, preserveAspectRatio:AspectRatioPreservation = .default, style:[RuleSet] = [], defs:[SVGChild] = [], children:[SVGChild] = []) {
		viewBox = Rect(origin: .zero, size: size)
		self.preserveAspectRatio = preserveAspectRatio
		self.style = style
		self.defs = defs
		self.children = children
	}
	
	public var viewBox:Rect
	public var preserveAspectRatio:AspectRatioPreservation
	
	public var style:[RuleSet] = []
	public var defs:[SVGChild] = []
	public var children:[SVGChild] = []
	
	///node name must be "svg"
	public init(xmlItem:XMLItem)throws {
		//extract the viewBox
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
		//FIXME: if viewBox was not provided directly, create it by finding the bounding box of all internal elements
		
		//extract the style child
		if let styleChild = xmlItem.child(named: "style") {
			style = [RuleSet](css: styleChild.childString)
		}
		let childFactory:SVGChildFactory = SVGChildFactory()
		
		//extract the  defs child
		if let defsChild = xmlItem.child(named: "defs") {
			defs = defsChild.children
				.compactMap({ $0 as? XMLItem })
				.compactMap(childFactory.child(xmlItem:))
		}
		
		//extract the other children
		children = xmlItem.children
			.compactMap({ $0 as? XMLItem })
			.compactMap(childFactory.child(xmlItem:))
	}
	
	
	public var xmlItem:XMLItem {
		var allChildren:[XMLItem] = [
			XMLItem(name: "style", attributes: ["type":"text/css"], children:[style.map({ $0.cssString }).joined(separator: "\n")]),
			XMLItem(name: "defs", attributes: [:], children: defs.map({ $0.xmlItem })),
		]
		allChildren.append(contentsOf:children.map({ $0.xmlItem }))
		return XMLItem(name: "svg"
			,attributes: [
				"xmlns" : "http://www.w3.org/2000/svg",
				"viewBox" : "\(viewBox.origin.x) \(viewBox.origin.y) \(viewBox.size.width) \(viewBox.size.height)",
				"preserveAspectRatio" : preserveAspectRatio.xmlAttribute
			]
			,children: allChildren)
	}
	
	
	///replaces all use children with a copy of their 
	public func resolveUseElements() {
		resolveUseElements(in: self)
	}
	
	internal func resolveUseElements(in container:SVGChildContainer ) {
		for (i, child) in container.children.enumerated() {
			if let groupChild:SVGChildContainer = child as? SVGChildContainer {
				resolveUseElements(in: groupChild)
				continue
			}
			guard let useChild:UseElement = child as? UseElement
				,let href:String = useChild.defId
				,let urlComponents:URLComponents = URLComponents(string: href)
				,urlComponents.host == nil	//we're not supporting downloads at this time
				,let fragment:String = urlComponents.fragment
				else { continue }
			guard let copiedChild = defs.filter({$0.id == fragment }).first?.deepCopy ?? childWithId(fragment)?.deepCopy else { continue }
			if var drawableChild = copiedChild as? DrawableChild {
				if let useX = useChild.x {
					drawableChild.x = useX
				}
				if let useY = useChild.y {
					drawableChild.y = useY
				}
				if let useWidth = useChild.width {
					drawableChild.width = useWidth
				}
				if let useHeight = useChild.height {
					drawableChild.height = useHeight
				}
			}
			container.children[i] = copiedChild
		}
	}
	
}
