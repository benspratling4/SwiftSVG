//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/15/20.
//

import Foundation
import SwiftGraphicsCore


extension SampledImage {
	
	///convenience method, creates a temporary SampledGraphicsContext and renders the SVGImage into the context
	///if no size is provided, it uses the viewBox from the SVGImage
	public convenience init(svgImage:SVGImage, size:Size? = nil) {
		let finalSize:Size = size ?? svgImage.viewBox.size
		self.init(width:Int(finalSize.width.rounded()), height:Int(finalSize.height.rounded()), colorSpace:GenericRGBAColorSpace(hasAlpha: true), bytes:nil)
		let context = SampledGraphicsContext(imageBuffer: self)
		context.drawSVG(svgImage, in: Rect(origin: .zero, size: finalSize))
	}
	
}
