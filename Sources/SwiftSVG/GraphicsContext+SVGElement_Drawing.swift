//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/15/20.
//

import Foundation
import SwiftGraphicsCore


extension GraphicsContext {
	
	///to draw an SVGElement into any GraphicsContext
	public func drawSVG(_ svg:SVGImage, in rect:Rect) {
		//using viewBox and AspectRatioPreservation, set up the initial transform and save the G state
		currentState.applyTransformation(svg.preserveAspectRatio.transform(viewBox: svg.viewBox, drawnIn: rect))
		
		
		
		//TODO: write me
		
		
		
	}
	
}
