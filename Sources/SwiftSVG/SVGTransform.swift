//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/17/20.
//

import Foundation
import SwiftGraphicsCore
import SwiftCSS



public enum SVGTransform {
	case matrix(a:SGFloat, b:SGFloat, c:SGFloat, d:SGFloat, dx:SGFloat, dy:SGFloat)
	case translate(x:SGFloat, y:SGFloat)
	case scale(x:SGFloat, y:SGFloat)
	case rotate(angle:SGFloat/*radians*/, center:Point?)
	case skew(angleX:SGFloat, angleY:SGFloat)
}


extension Scanner {
	
	//FIXME: support units
	public func scanSVGTransform(requireUnits:Bool = false)->[SVGTransform]? {
		var transforms:[SVGTransform] = []
		_ = try? scanCharactersFromSet(.whitespacesAndNewlines)
		while !self.isAtEnd {
			if scanString("matrix(") != nil {
				guard let newTranform = scanSVGMatrixTransform(requireUnits: requireUnits) else { return nil }
				transforms.append(newTranform)
			}
			else if scanString("translate(") != nil {
				guard let newTranform = scanSVGTranslateTransform(requireUnits: requireUnits) else { return nil }
				transforms.append(newTranform)
			}
			else if scanString("scale(") != nil {
				guard let newTranform = scanSVGScaleTransform(requireUnits: requireUnits) else { return nil }
				transforms.append(newTranform)
			}
			else if scanString("rotate(") != nil {
				guard let newTranform = scanSVGRotateTransform(requireUnits: requireUnits) else { return nil }
				transforms.append(newTranform)
			}
			else if scanString("skew(") != nil {
				guard let newTranform = scanSVGSkewTransform(requireUnits: requireUnits) else { return nil }
				transforms.append(newTranform)
			}
			_ = try? scanCharactersFromSet(.whitespacesAndNewlines)
		}
		
		return transforms
	}
	
	internal func scanSVGMatrixTransform(requireUnits:Bool = false)->SVGTransform? {
		let doubles:[Float64] = scanDoublesUntilNoLongerScanable()
		_ = try? scanCharactersFromSet(.whitespacesAndNewlines)
		if scanString(")") == nil {
			return nil
		}
		guard doubles.count == 6 else { return nil }
		return .matrix(a: doubles[0], b: doubles[1], c: doubles[2], d: doubles[3], dx: doubles[4], dy: doubles[5])
	}
	
	internal func scanSVGTranslateTransform(requireUnits:Bool = false)->SVGTransform? {
		let doubles:[Float64] = scanDoublesUntilNoLongerScanable()
		_ = try? scanCharactersFromSet(.whitespacesAndNewlines)
		if scanString(")") == nil {
			return nil
		}
		guard doubles.count > 1, doubles.count < 3 else { return nil }
		return .translate(x: doubles[0], y: doubles.last!)
	}
	
	internal func scanSVGScaleTransform(requireUnits:Bool = false)->SVGTransform? {
		let doubles:[Float64] = scanDoublesUntilNoLongerScanable()
		_ = try? scanCharactersFromSet(.whitespacesAndNewlines)
		if scanString(")") == nil {
			return nil
		}
		guard doubles.count > 1, doubles.count < 3 else { return nil }
		return .scale(x: doubles[0], y: doubles.last!)
	}
	
	internal func scanSVGSkewTransform(requireUnits:Bool = false)->SVGTransform? {
		let doubles:[Float64] = scanDoublesUntilNoLongerScanable()
		_ = try? scanCharactersFromSet(.whitespacesAndNewlines)
		if scanString(")") == nil {
			return nil
		}
		guard doubles.count > 1, doubles.count < 3 else { return nil }
		return .skew(angleX: doubles[0], angleY: doubles.last!)
	}
	
	internal func scanSVGRotateTransform(requireUnits:Bool = false)->SVGTransform? {
		let doubles:[Float64] = scanDoublesUntilNoLongerScanable()
		_ = try? scanCharactersFromSet(.whitespacesAndNewlines)
		if scanString(")") == nil {
			return nil
		}
		if doubles.count == 1 {
			return .rotate(angle: SGFloat.pi * doubles[0] / 180.0, center: nil)
		} else if doubles.count == 3 {
			let angle:SGFloat = SGFloat.pi * doubles[0] / 180.0
			let center:Point = Point(x: doubles[1], y: doubles[2])
			return .rotate(angle: angle, center: center)
		} else { return nil }
	}
}



extension Transform2D {
	public var svgString:String {
		return "matrix(\(a) \(b) \(c) \(d) \(dx) \(dy))"
	}
}


extension SVGTransform {
	
	///supply the center of the user coordinates,
	public func transform2D(center:Point)->Transform2D {
		switch self {
		case .matrix(a: let a, b: let b, c: let c, d: let d, dx: let dx, dy: let dy):
			return Transform2D(a: a, b: b, c: c, d: d, dx: dx, dy: dy)
		case .translate(x: let dx, y: let dy):
			return Transform2D(translateX: dx, y: dy)
		case .skew(angleX: let anglex, angleY: let angley):
			//FIXME: re-base center of transform
			return Transform2D(skewAngleX:anglex, y:angley)
		case .scale(x: let x, y: let y):
			return Transform2D(scaleX: x, scaleY: y)
		case .rotate(angle: let angle, center: let centerOrNil):
			//FIXME: there's an error in how this is computed
			let centerToUse:Point = centerOrNil ?? center
			return Transform2D(translateX:-centerToUse.x, y:-centerToUse.y)
				.concatenate(with: Transform2D(rotation: angle))
				.concatenate(with: Transform2D(translateX:centerToUse.x, y:centerToUse.y))
		}
	}
	
	public var svgString:String {
		switch self {
		case .matrix(a: let a, b: let b, c: let c, d: let d, dx: let dx, dy: let dy):
			return "matrix(\(a) \(b) \(c) \(d) \(dx) \(dy))"
			
		case .translate(x: let dx, y: let dy):
			return "translate(\(dx) \(dy))"
			
		case .scale(x: let x, y: let y):
			return "scale(\(x) \(y))"
			
		case .rotate(angle: let angle, center: let centerOrNil):
			let degrees:SGFloat = 180.0*angle/SGFloat.pi
			if let center:Point = centerOrNil {
				return "rotate(\(degrees) \(center.x) \(center.y))"
			} else {
				return "rotate(\(degrees))"
			}
			
		case .skew(angleX: let angleX, angleY: let angleY):
			let degreesX:SGFloat = 180.0*angleX/SGFloat.pi
			let degreesY:SGFloat = 180.0*angleY/SGFloat.pi
			return "skew(\(degreesX) \(degreesY))"
		}
	}
	
}


extension Array where Element == SVGTransform {
	public var svgString:String {
		return map({ $0.svgString }).joined(separator: " ")
	}
	
	public func transform2D(center:Point)->Transform2D {
		//FIXME: this is probably wrong?  Shouldn't center get adjusted for some elements
		return reduce(.identity) { $0.concatenate(with:$1.transform2D(center:center)) }
	}
}
