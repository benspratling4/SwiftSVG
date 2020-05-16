//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/15/20.
//

import Foundation
import SwiftGraphicsCore
import SwiftCSS

extension SampledColor {
	
	public var cssColor:CSSColor? {
		if components.count == 4 {
			return .rgb(components[0][0], components[1][0], components[2][0])
		} else if components.count == 3 {
			return .rgba(components[0][0], components[1][0], components[2][0], Float(components[3][0]))
		} else {
			return nil
		}
	}
	
	///Assumes 8-bit GenericRGBA color space
	public init(cssColor:CSSColor) {
		self.init(components: cssColor.resolvedRGBA().flatMap({ $0.map({ [$0] }) }) ?? [[0],[0],[0],[0]])
	}
	
}
