import XCTest
@testable import SwiftSVG
import SwiftPatterns
import SwiftGraphicsCore
import SwiftPNG

final class SwiftSVGTests: XCTestCase {
	
	func testSimplePath() {
		let svg:String = """
<!-- Generator: Adobe Illustrator 24.0.1, SVG Export Plug-In  -->
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="219.9px"
	 height="218px" viewBox="0 0 219.9 218" style="enable-background:new 0 0 219.9 218;" xml:space="preserve">
<style type="text/css">
	.st0{fill:#000145;}
	.st1{fill:#0052D9;stroke:#FFFFFF;stroke-width:3.6359;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;}
</style>
<defs>
</defs>
<path class="st1" fill="#0052D9" stroke="#FFFFFF" style="stroke-width:3.6359;" d="M153.3,107.9c13.5,2.9,23.6,7.5,30.3,13.8c9.3,8.8,13.9,19.6,13.9,32.3c0,9.7-3.1,18.9-9.2,27.8
	c-6.1,8.9-14.5,15.3-25.2,19.4c-10.7,4.1-27,6.1-48.9,6.1H22.3V202h7.3c8.1,0,14-2.6,17.5-7.8c2.2-3.4,3.3-10.5,3.3-21.4V47
	c0-12.1-1.4-19.7-4.2-22.8c-3.7-4.2-9.3-6.3-16.7-6.3h-7.3v-5.3h84.1c15.7,0,28.3,1.1,37.8,3.4c14.4,3.4,25.3,9.6,32.9,18.3
	c7.6,8.8,11.3,18.8,11.3,30.2c0,9.8-3,18.5-8.9,26.2C173.6,98.5,164.9,104.2,153.3,107.9z M78.1,100.2c3.5,0.7,7.6,1.2,12.1,1.5
	s9.5,0.5,15,0.5c14,0,24.5-1.5,31.5-4.5c7-3,12.4-7.6,16.2-13.9c3.7-6.2,5.6-13,5.6-20.4c0-11.4-4.6-21.1-13.9-29.2
	c-9.3-8-22.8-12.1-40.6-12.1c-9.6,0-18.2,1.1-25.8,3.2V100.2z M78.1,193.2c11.1,2.6,22.1,3.9,32.9,3.9c17.3,0,30.5-3.9,39.6-11.7
	c9.1-7.8,13.6-17.4,13.6-28.9c0-7.6-2.1-14.8-6.2-21.8c-4.1-7-10.8-12.5-20.1-16.5c-9.3-4-20.8-6-34.5-6c-5.9,0-11,0.1-15.2,0.3
	c-4.2,0.2-7.6,0.5-10.2,1V193.2z"/>
</svg>
"""
		guard let xmlItem = try? DataToXMLItemFactory(data: svg.data(using: .utf8)!).documentItem
			,let svgItem:XMLItem = xmlItem.child(named: "svg")
			else {
			XCTFail("unable to parse xml")
			return
		}
		
		guard let svgImage:SVGImage = try? SVGImage(xmlItem: svgItem) else {
			XCTFail("unable to interpret svg")
			return
		}
//		print(svgImage)
		let rasterImage = SampledImage(svgImage: svgImage)
		guard let pngData = rasterImage.pngData else {
			XCTFail("unable to make PNG")
			return
		}
		
		let url = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("svg rendered B.png")
		_ = try? pngData.write(to: url)
	}
	

	func testCubicStokes() {
		let svg:String = """
<!-- Generator: Adobe Illustrator 24.0.1, SVG Export Plug-In  -->
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="219.9px"
	 height="218px" viewBox="0 0 219.9 218" style="enable-background:new 0 0 219.9 218;" xml:space="preserve">
<style type="text/css">
	.st0{fill:#000145;}
	.st1{fill:#0052D9;stroke:#FFFFFF;stroke-width:3.6359;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;}
</style>
<defs>
</defs>
<path class="st1" fill="#0052D9" stroke="#FFFFFF" style="stroke-width:2.0;" d="M153.3,107.9c13.5,2.9,23.6,7.5,30.3,13.8c9.3,8.8,13.9,19.6,13.9,32.3c0,9.7-3.1,18.9-9.2,27.8
	c-6.1,8.9-14.5,15.3-25.2,19.4c-10.7,4.1-27,6.1-48.9,6.1H22.3V202h7.3c8.1,0,14-2.6,17.5-7.8c2.2-3.4,3.3-10.5,3.3-21.4V47
	c0-12.1-1.4-19.7-4.2-22.8c-3.7-4.2-9.3-6.3-16.7-6.3h-7.3v-5.3h84.1c15.7,0,28.3,1.1,37.8,3.4c14.4,3.4,25.3,9.6,32.9,18.3
	c7.6,8.8,11.3,18.8,11.3,30.2c0,9.8-3,18.5-8.9,26.2C173.6,98.5,164.9,104.2,153.3,107.9z M78.1,100.2c3.5,0.7,7.6,1.2,12.1,1.5
	s9.5,0.5,15,0.5c14,0,24.5-1.5,31.5-4.5c7-3,12.4-7.6,16.2-13.9c3.7-6.2,5.6-13,5.6-20.4c0-11.4-4.6-21.1-13.9-29.2
	c-9.3-8-22.8-12.1-40.6-12.1c-9.6,0-18.2,1.1-25.8,3.2V100.2z M78.1,193.2c11.1,2.6,22.1,3.9,32.9,3.9c17.3,0,30.5-3.9,39.6-11.7
	c9.1-7.8,13.6-17.4,13.6-28.9c0-7.6-2.1-14.8-6.2-21.8c-4.1-7-10.8-12.5-20.1-16.5c-9.3-4-20.8-6-34.5-6c-5.9,0-11,0.1-15.2,0.3
	c-4.2,0.2-7.6,0.5-10.2,1V193.2z"/>
</svg>
"""
		guard let xmlItem = try? DataToXMLItemFactory(data: svg.data(using: .utf8)!).documentItem
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
		
		let url = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("svg rendered B stroke.png")
		_ = try? pngData.write(to: url)
		
	}
	
	
	
	func testBlueB() {
		
		let svg:String = """
<!-- Generator: Adobe Illustrator 24.0.1, SVG Export Plug-In  -->
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="219.9px"
	 height="218px" viewBox="0 0 219.9 218" style="enable-background:new 0 0 219.9 218;" xml:space="preserve">
<style type="text/css">
	.st0{fill:#000145;}
	.st1{fill:#0052D9;stroke:#FFFFFF;stroke-width:3.6359;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;}
</style>
<defs>
</defs>
<rect class="st0" width="219.9" height="218"/>
<g>
	<path class="st1" d="M153.3,107.9c13.5,2.9,23.6,7.5,30.3,13.8c9.3,8.8,13.9,19.6,13.9,32.3c0,9.7-3.1,18.9-9.2,27.8
		c-6.1,8.9-14.5,15.3-25.2,19.4c-10.7,4.1-27,6.1-48.9,6.1H22.3V202h7.3c8.1,0,14-2.6,17.5-7.8c2.2-3.4,3.3-10.5,3.3-21.4V47
		c0-12.1-1.4-19.7-4.2-22.8c-3.7-4.2-9.3-6.3-16.7-6.3h-7.3v-5.3h84.1c15.7,0,28.3,1.1,37.8,3.4c14.4,3.4,25.3,9.6,32.9,18.3
		c7.6,8.8,11.3,18.8,11.3,30.2c0,9.8-3,18.5-8.9,26.2C173.6,98.5,164.9,104.2,153.3,107.9z M78.1,100.2c3.5,0.7,7.6,1.2,12.1,1.5
		s9.5,0.5,15,0.5c14,0,24.5-1.5,31.5-4.5c7-3,12.4-7.6,16.2-13.9c3.7-6.2,5.6-13,5.6-20.4c0-11.4-4.6-21.1-13.9-29.2
		c-9.3-8-22.8-12.1-40.6-12.1c-9.6,0-18.2,1.1-25.8,3.2V100.2z M78.1,193.2c11.1,2.6,22.1,3.9,32.9,3.9c17.3,0,30.5-3.9,39.6-11.7
		c9.1-7.8,13.6-17.4,13.6-28.9c0-7.6-2.1-14.8-6.2-21.8c-4.1-7-10.8-12.5-20.1-16.5c-9.3-4-20.8-6-34.5-6c-5.9,0-11,0.1-15.2,0.3
		c-4.2,0.2-7.6,0.5-10.2,1V193.2z"/>
</g>
</svg>

"""
		
		
		
		
	}
	
	
	
	
	
	
	

    static var allTests = [
        ("testSimplePath", testSimplePath),
    ]
}
