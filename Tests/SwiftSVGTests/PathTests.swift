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
		let capitalSerifB:String = "M27,19.7c2.8,0.6,4.9,1.5,6.2,2.8c1.9,1.8,2.9,4,2.9,6.7c0,2,-0.6,3.9,-1.9,5.7c-1.3,1.8,-3,3.2,-5.2,4c-2.2,0.8,-5.6,1.3,-10.1,1.3H0v-1.1h1.5c1.7,0,2.9,-0.5,3.6,-1.6c0.5,-0.7,0.7,-2.2,0.7,-4.4V7.1c0,-2.5,-0.3,-4.1,-0.9,-4.7C4.2,1.5,3,1.1,1.5,1.1H0V0h17.4c3.2,0,5.8,0.2,7.8,0.7c3,0.7,5.2,2,6.8,3.8c1.6,1.8,2.3,3.9,2.3,6.2c0,2,-0.6,3.8,-1.8,5.4C31.2,17.7,29.4,18.9,27,19.7z M11.5,18.1c0.7,0.1,1.6,0.2,2.5,0.3s2,0.1,3.1,0.1c2.9,0,5,-0.3,6.5,-0.9c1.5,-0.6,2.6,-1.6,3.3,-2.9s1.2,-2.7,1.2,-4.2c0,-2.4,-1,-4.4,-2.9,-6C23.3,2.8,20.5,2,16.8,2c-2,0,-3.8,0.2,-5.3,0.7V18.1z M11.5,37.3c2.3,0.5,4.6,0.8,6.8,0.8c3.6,0,6.3,-0.8,8.2,-2.4c1.9,-1.6,2.8,-3.6,2.8,-6c0,-1.6,-0.4,-3.1,-1.3,-4.5c-0.8,-1.4,-2.2,-2.6,-4.1,-3.4c-1.9,-0.8,-4.3,-1.2,-7.1,-1.2c-1.2,0,-2.3,0,-3.1,0.1c-0.9,0,-1.6,0.1,-2.1,0.2V37.3z"
		let bPath:Path
		do {
			bPath = try Path(svg_d:capitalSerifB)
			print(" ")
		} catch {
			print(error)
			XCTFail("Unable to parse B")
			fatalError()
		}
		print(bPath)

		let colorSpace:ColorSpace = GenericRGBAColorSpace(hasAlpha: true)
		let context = SampledGraphicsContext(dimensions: Size(width: 50.0, height: 50.0), colorSpace: colorSpace)
		context.antialiasing = .subsampling(resolution: .three)
		context.fillPath(bPath, color:colorSpace.black)
		
		
//		guard let pngData = context.image.pngData else {
//			XCTFail("couldn't get png data")
//			return
//		}
//		let outputFilePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("test draw letter B.png")
//		try? pngData.write(to: outputFilePath)
		
	}
	
}
