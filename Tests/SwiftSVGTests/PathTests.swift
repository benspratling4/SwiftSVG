//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/4/20.
//

import Foundation
import XCTest
import SwiftGraphicsCore
@testable import SwiftSVG
//import SwiftPNG


class PathTests:XCTestCase {
	
	
	func testParsingPathDString() {
		let capitalSerifB:String = "M26.7,19.5c2.8,0.6,4.8,1.5,6.2,2.8c1.9,1.8,2.8,4,2.8,6.6c0,2,-0.6,3.9,-1.9,5.7s-3,3.1,-5.1,4s-5.5,1.2,-10,1.2H0v-1.1h1.5c1.7,0,2.9,-0.5,3.6,-1.6c0.4,-0.7,0.7,-2.1,0.7,-4.4V7c0,-2.5,-0.3,-4,-0.8,-4.7C4.1,1.5,3,1.1,1.5,1.1H0V0h17.2c3.2,0,5.8,0.2,7.7,0.7c2.9,0.7,5.2,1.9,6.7,3.7s2.3,3.8,2.3,6.2c0,2,-0.6,3.8,-1.8,5.3C30.9,17.5,29.1,18.7,26.7,19.5z M11.4,17.9c0.7,0.1,1.5,0.2,2.5,0.3c0.9,0.1,1.9,0.1,3.1,0.1c2.9,0,5,-0.3,6.4,-0.9s2.5,-1.6,3.3,-2.8c0.8,-1.3,1.1,-2.7,1.1,-4.2c0,-2.3,-0.9,-4.3,-2.8,-5.9S20.3,2,16.6,2c-2,0,-3.7,0.2,-5.3,0.6V17.9z M11.4,36.9c2.3,0.5,4.5,0.8,6.7,0.8c3.5,0,6.2,-0.8,8.1,-2.4s2.8,-3.6,2.8,-5.9c0,-1.5,-0.4,-3,-1.3,-4.5s-2.2,-2.5,-4.1,-3.4s-4.2,-1.2,-7,-1.2c-1.2,0,-2.2,0,-3.1,0.1c-0.9,0,-1.6,0.1,-2.1,0.2V36.9z"
		
		guard let bPath = try? Path(svg_d:capitalSerifB) else {
			XCTFail("Unable to parse B")
			return
		}
		print(bPath)

		let colorSpace:ColorSpace = GenericRGBAColorSpace(hasAlpha: true)
		let context = SampledGraphicsContext(dimensions: Size(width: 50.0, height: 50.0), colorSpace: colorSpace)
		context.antialiasing = .subsampling(resolution: .three)
		context.fillPath(bPath, color:colorSpace.black)
		
		/*
		guard let pngData = context.image.pngData else {
			XCTFail("couldn't get png data")
			return
		}
		let outputFilePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("test draw letter B.png")
		try? pngData.write(to: outputFilePath)
		*/
	}
	
}
