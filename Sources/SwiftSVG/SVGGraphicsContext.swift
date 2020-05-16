//
//  File.swift
//  
//
//  Created by Ben Spratling on 5/13/20.
//

import Foundation
import SwiftGraphicsCore
import SwiftCSS

///conforms to GraphicsContext, and when asked, can produce an SVGImage, which can produce SVG XML
public class SVGGraphicsContext : GraphicsContext {
	
	public init(size: Size, colorSpace: ColorSpace = GenericRGBAColorSpace(hasAlpha: true)) {
		self.size = size
		self.colorSpace = colorSpace
		self.svgImage = SVGImage(size: size)
	}
	
	///This is your output
	public var svgImage:SVGImage
	
	
	//MARK: - GraphicsContext
	
	public var size: Size
	
	public var colorSpace: ColorSpace
	
	public func drawPath(_ path: Path, fillShader: Shader?, stroke: (Shader, StrokeOptions)?) {
		let path = PathElement(path: path, id: nil, classes: [])
		path.fillShader = fillShader
		path.strokeShader = stroke?.0
		path.strokeWidth = stroke.flatMap({ SwiftCSS.Dimension(number: $0.1.lineWidth, unit:AbsoluteLengthUnits.px) })
		svgImage.children.append(path)
	}
	
	public func drawImage(_ image: SampledImage, in rect: Rect) {
		//TODO: write me
	}
	
	
	//state stack management
	//FIXME: this is the old sampled context state stack, re-implement using groups
	
	public func saveState() {
		states.append(GraphicsContextState(transformation:states.last?.transformation ?? .identity))
	}
	
	public func popState() {
		states.removeLast()
	}
	
	private var states:[GraphicsContextState] = [GraphicsContextState()]
	
	public var currentState:ResolvedGraphicsContextState {
		return ProxyState(context: self)
	}
	
	private func resolveStateProperty<Value>(key:KeyPath<GraphicsContextState,Optional<Value>>)->Optional<Value> {
		for state in states.reversed() {
			if let value = state[keyPath:key] {
				return value
			}
		}
		return nil
	}
	
	class ProxyState : ResolvedGraphicsContextState {
		var transformation: Transform2D {
			get {
				guard let stateCount:Int = context?.states.count, stateCount > 0 else { return .identity }
				return context?.states[stateCount-1].transformation ?? .identity
			}
		}
		
		func applyTransformation(_ transformation:Transform2D) {
			guard let context = self.context, context.states.count > 0 else { return }
			let oldTransformation = context.states[context.states.count-1].transformation
			let newTransformation = oldTransformation.concatenate(with:transformation)
			context.states[context.states.count-1].transformation = newTransformation
		}
		
		init(context:SVGGraphicsContext) {
			self.context = context
		}
		
		private weak var context:SVGGraphicsContext?
		
	}
	
}
