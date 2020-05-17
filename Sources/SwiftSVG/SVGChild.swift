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


public protocol SVGChild {
	
	var xmlItem:XMLItem  { get }
	var id:String? { get }
	
	var deepCopy:SVGChild? { get }
	
}

public protocol SVGChildContainer : class {
	var children:[SVGChild]  { get set }
}

extension SVGChildContainer {
	
	public func childWithId(_ id:String)->SVGChild? {
		for child in children {
			if child.id == id {
				return child
			}
			if let container = child as? SVGChildContainer
				,let foundChild = container.childWithId(id) {
				return foundChild
			}
		}
		return nil
	}
}


public class SVGChildFactory {
	
	public var knownChildNodeInitMethods:[String:(XMLItem)->(SVGChild?)] = [
		"path":PathElement.init(xmlItem:),
		"use":UseElement.init(xmlItem:),
		"g":GroupElement.init(xmlItem:),
	]
	
	public func child(xmlItem:XMLItem)->SVGChild? {
		return knownChildNodeInitMethods[xmlItem.name ?? ""]?(xmlItem)
	}
	
}


public protocol DrawableChild : SVGChild {
	
	func draw(in context:GraphicsContext)
	
	var boundingBox:Rect { get }
	
	var x:SwiftCSS.Dimension? { get set }
	var y:SwiftCSS.Dimension? { get set }
	var width:SwiftCSS.Dimension? { get set }
	var height:SwiftCSS.Dimension? { get set }
	var transforms:[SVGTransform] { get set }
 
	
}
