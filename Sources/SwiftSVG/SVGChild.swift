//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/15/20.
//

import Foundation
import SwiftPatterns
import SwiftGraphicsCore


public protocol SVGChild {
	
	var xmlItem:XMLItem  { get }
	var id:String? { get }
	
}


public class SVGChildFactory {
	
	public var knownChildNodeInitMethods:[String:(XMLItem)->(SVGChild?)] = [
		"path":PathElement.init(xmlItem:)
	]
	
	public func child(xmlItem:XMLItem)->SVGChild? {
		return knownChildNodeInitMethods[xmlItem.name ?? ""]?(xmlItem)
	}
	
}


public protocol DrawableChild : SVGChild {
	
	func draw(in context:GraphicsContext)
	
	var boundingBox:Rect { get }
	
}
