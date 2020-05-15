//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/8/20.
//

import Foundation
import SwiftPatterns
import SwiftCSS



public protocol HTMLXMLNodeChild {
}


public class HTMLXMLNode : HTMLXMLNodeChild {
	public var name:String
	public var attributes:[String:String]
	public var id:String?
	public var classes:[String]
	public var children:[HTMLXMLNodeChild]
	public var styleAttributes:[Declaration] = []
	public var resolvedStyle:[Declaration]?
	
	
	public convenience init(xmlItem:XMLItem) {
		self.init(name:xmlItem.name ?? ""
			,attributes:xmlItem.attributes
			,children:xmlItem.children.compactMap({
			if let string = $0 as? String {
				return string
			}
			if let xmlItem = $0 as? XMLItem {
				return HTMLXMLNode(xmlItem: xmlItem)
			}
			return nil
		}))
	}
	
	///extracts id and classes from attributes
	public init(name:String, attributes:[String:String], children:[HTMLXMLNodeChild]) {
		self.name = name
		self.children = children
		self.id = attributes["id"]
		self.classes = attributes["class"]?.components(separatedBy: " ") ?? []
		self.attributes = attributes
		styleAttributes = attributes["style"].flatMap({ [Declaration](inlineStyle:$0) }) ?? []
	}
	
	public var deepCopy:HTMLXMLNode {
		return HTMLXMLNode(name: name
			,attributes: attributes
			,children: children.map({ ($0 as? HTMLXMLNode)?.deepCopy ?? $0 }))
	}
}

extension String : HTMLXMLNodeChild {
	
}

