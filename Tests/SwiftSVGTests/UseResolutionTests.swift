//
//  UseResolutionTests.swift
//  
//
//  Created by Ben Spratling on 5/17/20.
//

import Foundation
import XCTest
import SwiftCSS
import SwiftPatterns
import SwiftGraphicsCore
@testable import SwiftSVG


class UseResolutionTests : XCTestCase {
	

	func testResolvignUse() {
		let svg:String = """
<!-- Generator: Adobe Illustrator 24.0.1, SVG Export Plug-In  -->
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="100px"
	 height="40px" viewBox="0 0 100 40" style="enable-background:new 0 0 219.9 218;" xml:space="preserve">
<style type="text/css">
	.st0{fill:#000145;}
	.st1{fill:#0052D9;stroke:#FFFFFF;stroke-width:3.6359;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;}
</style>
<defs>
<path id="square" fill="#0052D9" d="M10,10L30,10L30,30L10,30L10,10z"/>
</defs>
<use x="0" y="0" href="#square" xlink:href="#sqaure" />
<use x="40" y="0" href="#square" xlink:href="#sqaure" />
</svg>
"""
		guard let xmlItem = DataToXMLItemFactory(data: svg.data(using: .utf8)!).documentItem
			,let svgItem:XMLItem = xmlItem.child(named: "svg")
			else {
			XCTFail("unable to parse xml")
			return
		}
		
		guard let svgImage:SVGImage = try? SVGImage(xmlItem: svgItem) else {
			XCTFail("unable to interpret svg")
			return
		}
//			let subdividedPath:Path = svgImage.children.compactMap({$0 as? PathElement}).first!.path.subDivided(linearity: 0.16)
//			let v = PathElement(path: subdividedPath)
//			v.fillShader = SolidColorShader(color:SampledColor.init(cssColor: .named(.black)))
//			let newImage = SVGImage(size: svgImage.viewBox.size, preserveAspectRatio: svgImage.preserveAspectRatio, style: [], defs: [], children: [v])
		
	//	print(newImage.xmlItem.string)
//		print(svgImage)
		let rasterImage = SampledImage(svgImage: svgImage)
		guard let pngData = rasterImage.pngData else {
			XCTFail("unable to make PNG")
			return
		}
		
		let url = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("svgRenderedUse.png")
		_ = try? pngData.write(to: url)
		
	}
		
	
}
