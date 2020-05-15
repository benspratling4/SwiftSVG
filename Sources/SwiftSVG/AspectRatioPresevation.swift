//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/13/20.
//

import Foundation
import SwiftGraphicsCore

public struct AspectRatioPreservation {
	
	public init(align:Align = .xMidYMid, meetOrSlice:MeetOrSlice = .meet) {
		self.align = align
		self.meetOrSlice = meetOrSlice
	}
	
	public init?(string:String) {
		let scanner = Scanner(string: string)
		_ = try? scanner.scanCharactersInSet(.whitespacesAndNewlines)
		guard let alignString:String = try? scanner.scanCharactersInSet(.letters)
			else {
				return nil
		}
		self.align = Align(rawValue: alignString) ?? .default
		_ = try? scanner.scanCharactersInSet(.whitespacesAndNewlines)
		
		if align == .none {
			meetOrSlice = .default	//ignored
			return
		}
		if let meetOrSliceString:String = try? scanner.scanCharactersInSet(.letters)
			,let meetOrSlice = MeetOrSlice(rawValue: meetOrSliceString) {
			self.meetOrSlice = meetOrSlice
		} else {
			self.meetOrSlice = .default
		}
		
		
	}
	
	public var align:Align
	public var meetOrSlice:MeetOrSlice
	
	public enum Align : String {
		case none, xMinYMin, xMidYMin, xMaxYMin, xMinYMid, xMidYMid, xMaxYMid, xMinYMax, xMidYMax, xMaxYMax
		
		public static let `default`:Align = .xMidYMid
	}
	
	public enum MeetOrSlice : String {
		case meet, slice
		
		public static let `default`:MeetOrSlice = .meet
	}
	
	public static let `default`:AspectRatioPreservation = AspectRatioPreservation(align: .default, meetOrSlice: .default)
	
	public var xmlAttribute:String {
		if align == .none {
			return align.rawValue
		} else {
			return "\(align.rawValue) \(meetOrSlice.rawValue)"
		}
	}
	
	///returns a transform which maps the viewBox coordinates into image coordinates
	public func transform(viewBox:Rect, drawnIn finalRect:Rect)->Transform2D {
		let startTransform:Transform2D = Transform2D(translateX:-viewBox.origin.x, y: -viewBox.origin.y)
		if align == .none {	//if removing this, address fatalError() below
			//stretch everything
			let nextTransform = startTransform.concatenate(with: Transform2D(scaleX: finalRect.size.width / viewBox.size.width, scaleY: finalRect.size.height / viewBox.size.height))
			return nextTransform.concatenate(with: Transform2D(translateX: finalRect.origin.x, y: finalRect.origin.y))
		}
		let xScale:SGFloat = finalRect.size.width / viewBox.size.width
		let yScale:SGFloat = finalRect.size.height / viewBox.size.height
		let selectedScale:SGFloat
		switch meetOrSlice {
		case .meet:
			//take the smaller scale
			selectedScale = min(xScale, yScale)
		case .slice:
			selectedScale = max(xScale, yScale)
		}
		let scaleTransform:Transform2D = startTransform.concatenate(with: Transform2D(scaleX: selectedScale, scaleY: selectedScale))
		let scaledWidth:SGFloat = viewBox.size.width * selectedScale
		
		
		let leftOffset:SGFloat
		switch align {
		case .xMinYMax, .xMinYMid, .xMinYMax:
			leftOffset = 0.0
			
		case .xMidYMin, .xMidYMid, .xMidYMax:
			leftOffset = (finalRect.size.width - scaledWidth)/2.0
			
		case .xMaxYMin, .xMaxYMid, .xMaxYMax:
			leftOffset = finalRect.size.width - scaledWidth
			
		default:
			fatalError()	//.none already handled above
		}
		
		let scaledHeight:SGFloat = viewBox.size.height * selectedScale
		let topOffset:SGFloat
		
		switch align {
		case .xMinYMin, .xMidYMin, .xMaxYMin:
			topOffset = 0.0
			
		case .xMinYMid, .xMidYMid, .xMaxYMid:
			topOffset = (finalRect.size.height - scaledHeight)/2.0
			
		case .xMinYMax, .xMidYMax, .xMaxYMax:
			topOffset = finalRect.size.height - scaledHeight
			
		default:
			fatalError()	//.none already handled above
		}
		
		return scaleTransform.concatenate(with: Transform2D(translateX: leftOffset, y: topOffset))
	}
	
}

