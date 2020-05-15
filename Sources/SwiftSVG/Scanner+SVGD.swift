//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/4/20.
//

import Foundation

extension Scanner {
	
	enum ScannerError : Error {
		case failed(Any.Type, Int)	//scanLocation
	}
	
	func scanDouble()throws->Double {
		var value:Double = 0
		if scanDouble(&value) {
			return value
		}
		throw ScannerError.failed(Double.self, scanLocation)
	}
	
	
	func scanFloat()throws->Float {
		var value:Float = 0
		if scanFloat(&value) {
			return value
		}
		throw ScannerError.failed(Float.self, scanLocation)
	}
	
	func scanInt()throws->Int {
		var value:Int = 0
		if scanInt(&value) {
			return value
		}
		throw ScannerError.failed(Int.self, scanLocation)
	}
	
	
	func scanCharactersInSet(_ set:CharacterSet)throws->String {
		let text = try scanCharactersFromSet(set)
		return text
		/*
		var string:NSString?
		scanCharacters(from: set, into: &string)
		if let text = string {
			return text as String
		}
		throw ScannerError.failed
		*/
	}
	
	public func scanCharactersFromSet(_ set: CharacterSet)throws -> String {
		let str = self.string._bridgeToObjectiveC()
		var stringLoc = scanLocation
		let stringLen = str.length
		let options: NSString.CompareOptions = caseSensitive ? [] : NSString.CompareOptions.caseInsensitive
		if let invSkipSet = charactersToBeSkipped?.inverted {
			let range = str.rangeOfCharacter(from: invSkipSet, options: [], range: NSMakeRange(stringLoc, stringLen - stringLoc))
			stringLoc = range.length > 0 ? range.location : stringLen
		}
		var range = str.rangeOfCharacter(from: set.inverted, options: options, range: NSMakeRange(stringLoc, stringLen - stringLoc))
		if range.length == 0 {
			range.location = stringLen
		}
		if stringLoc != range.location {
			let res = str.substring(with: NSMakeRange(stringLoc, range.location - stringLoc))
			scanLocation = range.location
			return res
		}
		throw ScannerError.failed(String.self, scanLocation)
	}
	
	
	public func scanCharacterFromSet(_ set: CharacterSet)throws -> String {
		let str = self.string._bridgeToObjectiveC()
		var stringLoc = scanLocation
		let stringLen = str.length
		if isAtEnd { throw ScannerError.failed(Unicode.Scalar.self, scanLocation) }
		var char = str.character(at: stringLoc)
		guard let scalar = Unicode.Scalar(char) else { throw ScannerError.failed(Unicode.Scalar.self, scanLocation) }
		if set.contains(scalar) {
			scanLocation = scanLocation + 1
			let letter = NSString(characters: &char, length: 1)
			return letter as String
		}
		throw ScannerError.failed(Unicode.Scalar.self, scanLocation)
		/*
		let options: NSString.CompareOptions = caseSensitive ? [] : NSString.CompareOptions.caseInsensitive
		if let invSkipSet = charactersToBeSkipped?.inverted {
			let range = str.rangeOfCharacter(from: invSkipSet, options: [], range: NSMakeRange(stringLoc, stringLen - stringLoc))
			stringLoc = range.length > 0 ? range.location : stringLen
		}
		var range = str.rangeOfCharacter(from: set.inverted, options: options, range: NSMakeRange(stringLoc, stringLen - stringLoc))
		if range.length == 0 {
			range.location = stringLen
		}
		if stringLoc != range.location {
			let res = str.substring(with: NSMakeRange(stringLoc, range.location - stringLoc))
			scanLocation = range.location
			return res
		}
		return nil*/
	}
	
	
	
	/*
	func scanString()throws->String? {
		
	}
*/
	
}

extension CharacterSet {
	internal static let delimiterSet:CharacterSet = CharacterSet(charactersIn: ", \n\t")
}

extension Scanner {
	
	//can scan doubles separated by any whitespace, or nothing until it hits something that isnt a double
	func scanDoublesUntilNoLongerScanable()->[Double] {
		var answers:[Double] = []
		_ = try? scanCharactersInSet(.delimiterSet)
		while let newDouble:Double = scanDouble() {
			answers.append(newDouble)
			_ = try? scanCharactersInSet(.delimiterSet)
		}
		return answers
	}
	
	
	func scanSpaceSeparatedDoubles()throws->(Double, Double) {
		let x:Double = try scanDouble()
		_ = try scanCharactersFromSet(.delimiterSet)
		let y:Double = try scanDouble()
		return (x,y)
	}
	
	func scanDelimitedDoubles()throws->(Double, Double, Double, Double) {
		let a:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let b:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let c:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let d:Double = try scanDouble()
		return (a, b, c, d)
	}
	
	func scanDelimitedDoubles()throws->(Double, Double, Double, Double, Double, Double) {
		let a:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let b:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let c:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let d:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let e:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let f:Double = try scanDouble()
		return (a, b, c, d, e, f)
	}
	
	func scanDelimitedDoubles()throws->(Double, Double, Double, Double, Double, Double, Double) {
		let a:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let b:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let c:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let d:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let e:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let f:Double = try scanDouble()
		_ = try scanCharactersInSet(.delimiterSet)
		let g:Double = try scanDouble()
		return (a, b, c, d, e, f, g)
	}
	
}
