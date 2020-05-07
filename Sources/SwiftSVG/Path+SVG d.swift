//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/4/20.
//

import Foundation
import SwiftGraphicsCore


extension Path {
	
	///init with the "d" attribute from a "path" inside a "svg" element
	/// based on https://www.w3.org/TR/SVG/paths.html#PathData
	public init(svg_d:String)throws {
		self.init(subPaths: [])
		
		let scanner = Scanner(string: svg_d)
		scanner.charactersToBeSkipped = nil
		var previousCoords:(Double, Double)?
		while !scanner.isAtEnd {
			//scan a command
			//todo: this scans more than 1 character, we always only want 1
			let command:String = try scanner.scanCharactersInSet(Path.controlCharacterSet) //scanCharacterFromSet()
			switch command {
			case "M":
				let (x, y) = try scanner.scanSpaceSeparatedDoubles()
				move(to:Point(x:x, y:y))
				previousCoords = (x, y)
				
			case "m":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let (x, y) = try scanner.scanSpaceSeparatedDoubles()
				let finalCoords = (x + coords.0, y + coords.1)
				move(to:Point(x:finalCoords.0, y:finalCoords.1))
				previousCoords = finalCoords
				
			case "L":
				let (x, y) = try scanner.scanSpaceSeparatedDoubles()
				addLine(to: Point(x:x, y:y))
				previousCoords = (x, y)
				
			case "l":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let (x, y) = try scanner.scanSpaceSeparatedDoubles()
				let finalCoords = (x + coords.0, y + coords.1)
				addLine(to: Point(x:finalCoords.0, y:finalCoords.1))
				previousCoords = finalCoords
				
			case "H":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let _:String? = try? scanner.scanCharactersInSet(.delimiterSet)
				let x:Double = try scanner.scanDouble()
				let finalCoords = (x, coords.1)
				addLine(to: Point(x:finalCoords.0, y:finalCoords.1))
				previousCoords = finalCoords
				
			case "h":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let _:String? = try? scanner.scanCharactersInSet(.delimiterSet)
				let x:Double = try scanner.scanDouble()
				let finalCoords = (x+coords.0, coords.1)
				addLine(to: Point(x:finalCoords.0, y:finalCoords.1))
				previousCoords = finalCoords
				
			case "V":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let _:String? = try? scanner.scanCharactersInSet(.delimiterSet)
				let y:Double = try scanner.scanDouble()
				let finalCoords = (coords.0, y)
				addLine(to: Point(x:finalCoords.0, y:finalCoords.1))
				previousCoords = finalCoords
				
			case "v":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let _:String? = try? scanner.scanCharactersInSet(.delimiterSet)
				let y:Double = try scanner.scanDouble()
				let finalCoords = (coords.0, coords.1+y)
				addLine(to: Point(x:finalCoords.0, y:finalCoords.1))
				previousCoords = finalCoords
				
			case "Z", "z":
				//close path
				close()
//				let _:String? = try? scanner.scanCharactersInSet(.delimiterSet)
				
			case "Q":
				let (x1, y1, x2, y2) = try scanner.scanDelimitedDoubles()
				addCurve(near: Point(x: x1, y: y1), to: Point(x: x2, y: y2))
				previousCoords = (x2, y2)
				
			case "q":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let (x1, y1, x2, y2) = try scanner.scanDelimitedDoubles()
				let finalCoords = (coords.0+x2, coords.1+y2)
				addCurve(near: Point(x: x1+coords.0, y: y1+coords.1), to: Point(x: finalCoords.0, y: finalCoords.1))
				previousCoords = finalCoords
				
			case "C":
				let (x1, y1, x2, y2, x3, y3) = try scanner.scanDelimitedDoubles()
				addCurve(near: Point(x: x1, y: y1), and: Point(x: x2, y: y2), to: Point(x: x3, y: y3))
				previousCoords = (x3, y3)
				
			case "c":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let (x1, y1, x2, y2, x3, y3) = try scanner.scanDelimitedDoubles()
				let finalCoords = (coords.0+x3, coords.1+y3)
				addCurve(near: Point(x: coords.0+x1, y: coords.1+y1), and: Point(x: coords.0+x2, y: coords.1+y2), to: Point(x: finalCoords.0, y: finalCoords.1))
				previousCoords = finalCoords
				
			case "t":
				guard let coords = previousCoords else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				//previous segment must be a quadratic curve
				guard let segment = subPaths.last?.segments.last
					,case .quadratic(let control1) = segment.shape else {
					throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let end = segment.end
				//new control point is reflected over
				let diff = end - control1
				let newControl = end + diff
				let (x, y) = try scanner.scanSpaceSeparatedDoubles()
				let newEnd = (x + coords.0, y + coords.1)
				addCurve(near: newControl, to: Point(x: newEnd.0, y: newEnd.1))
				previousCoords = newEnd
				
			case "T":
				//previous segment must be a quadratic curve
				guard let segment = subPaths.last?.segments.last
					,case .quadratic(let control1) = segment.shape else {
						throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let end = segment.end
				//new control point is reflected over
				let diff = end - control1
				let newControl = end + diff
				let newEnd = try scanner.scanSpaceSeparatedDoubles()
				addCurve(near: newControl, to: Point(x: newEnd.0, y: newEnd.1))
				previousCoords = newEnd
				
			case "S":
				guard let segment = subPaths.last?.segments.last
					,case .cubic(_, let control2) = segment.shape else {
						throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let end = segment.end
				//new control point is reflected over
				let diff = end - control2
				let newControl1 = end + diff
				let (cx2, cy2, ex, ey) = try scanner.scanDelimitedDoubles()
				addCurve(near: newControl1, and: Point(x: cx2, y: cy2), to: Point(x: ex, y: ey))
				previousCoords = (ex, ey)
				
			case "s":
				guard let segment = subPaths.last?.segments.last
					,case .cubic(_, let control2) = segment.shape else {
						throw SVGPathFormatError.invalidFormat(scanner.scanLocation)
				}
				let end = segment.end
				//new control point is reflected over
				let diff = end - control2
				let newControl1 = end + diff
				let (cx2, cy2, ex, ey) = try scanner.scanDelimitedDoubles()
				let newControl2 = end + Point(x: cx2, y: cy2)
				let newEnd = end + Point(x: ex, y: ey)
				addCurve(near:newControl1, and:newControl2, to:newEnd)
				previousCoords = (newEnd.x, newEnd.y)
				
			case "a", "A":
				let (rx, ry, xAxisRotate, largeArcFlag, sweepFlag, x, y) = try scanner.scanDelimitedDoubles()
				throw SVGPathFormatError.unsuported(command)
				//TODO: write me
			default:
				throw SVGPathFormatError.unsuported(command)
			}
			
			//optional whitespace after the numbers, ignore error if one is thrown
			let _:String? = try? scanner.scanCharactersInSet(.delimiterSet)
		}
		
		
		
		
	}
	
	static let controlCharacterSet:CharacterSet = CharacterSet(charactersIn: "mMlLvVhHzZcCsSqQtTaA")
	
	enum SVGPathFormatError : Error {
		case invalidFormat(Int)	//the index where the format was not understood
		//commands known to be valid, but as yet unsupported
		case unsuported(String)
	}
}
