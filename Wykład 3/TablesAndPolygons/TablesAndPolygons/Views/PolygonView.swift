//
//  PolygonView.swift
//  TablesAndPolygons
//
//  Created by Kajetan Dąbrowski on 08.11.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import UIKit

@IBDesignable class PolygonView: UIView
{
	@IBInspectable var strokeColor: UIColor? {
		didSet {
			//color changed - we need to redraw
			self.setNeedsDisplay()
		}
	}
	
	@IBInspectable var fillColor: UIColor? {
		didSet {
			//color changed - we need to redraw
			self.setNeedsDisplay()
		}
	}
	
	@IBInspectable var lineWidth: CGFloat = 0.0 {
		didSet {
			//stroke changed - we need to redraw
			self.setNeedsDisplay()
		}
	}
	
	@IBInspectable var numberOfSides: Int = 3 {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	private class func unarVertexLocationForVertexAtIndex(index: Int, withNumberOfSides numberOfSides: Int) -> CGPoint {
		//
		let center: (x: CGFloat, y: CGFloat) = (0.5, 0.5)
		let circleRadius: CGFloat = 0.5
		
		// x and y computed from radial coordinates
		// https://en.wikipedia.org/wiki/Polar_coordinate_system
		let x: CGFloat = circleRadius * cos(CGFloat(2.0 * M_PI) * CGFloat(index) / CGFloat(numberOfSides))
		let y: CGFloat = circleRadius * sin(CGFloat(2.0 * M_PI) * CGFloat(index) / CGFloat(numberOfSides))
		
		return CGPointMake(center.x + x, center.y + y)
	}
	
	override func drawRect(rect: CGRect) {
		if self.numberOfSides < 3 { return }
		
		//Context that we'll draw in
		let context: CGContext? = UIGraphicsGetCurrentContext()
		
		//Bounding size INCLUDING STROKES
		let polygonBoundingSize: CGFloat = min(self.bounds.width, self.bounds.height)
		
		
		//Transforming from unar coordinates to our coordinates:
		//
		//1. Scale up to the size of actual polygon (polygonBoundingSize - half line width for each side)
		let scaleTransform: CGAffineTransform = CGAffineTransformMakeScale(polygonBoundingSize - self.lineWidth, polygonBoundingSize - self.lineWidth)
		
		//2. Move DOWN and RIGHT by half line width
		let translateByLineWidth: CGAffineTransform = CGAffineTransformMakeTranslation(self.lineWidth * 0.5, self.lineWidth * 0.5)
		
		//3. Mirror vertically
		let mirrorVertically: CGAffineTransform = CGAffineTransformMakeScale(1.0, -1.0)
		
		//4. Move back DOWN (after mirror it's in negative Y coordinates)
		let translateByBounds: CGAffineTransform = CGAffineTransformMakeTranslation(0.0, polygonBoundingSize)
		
		//5. Combine all transforms
		let transform: CGAffineTransform = CGAffineTransformConcat(scaleTransform, CGAffineTransformConcat(translateByLineWidth, CGAffineTransformConcat(mirrorVertically, translateByBounds)))
		
		/*
		*	Przykładowo rysujemy kwadrat 10x10. LineWidth = 2
		*
		*	Delegate zwraca nam pełen kwadrat: (0,0), (1,0), (1,1), (0,1)
		*	Chcemy to przetransformować w kwadrat (1,1), (9,1), (9,9), (1,9)
		*	(Zostawiliśmy z każdej strony 1pt (lineWidth * 0.5) miejsca na linię)
		*
		*/
		
		//Bezier path that we'll draw
		let bezierPath = UIBezierPath()
		
		for vertexIndex in 0..<self.numberOfSides {
			let coordinatesInUnarSpace: CGPoint = PolygonView.unarVertexLocationForVertexAtIndex(vertexIndex, withNumberOfSides: self.numberOfSides)
			//apply our transform to location returned by our dataSource
			let vertexLocation: CGPoint = CGPointApplyAffineTransform(coordinatesInUnarSpace, transform)
			
			//Just move to the first point - don't draw a line!
			if vertexIndex == 0 {
				bezierPath.moveToPoint(vertexLocation)
			}
				
			//Draw a line from last point to this point
			else {
				bezierPath.addLineToPoint(vertexLocation)
			}
		}
		
		//Last line: from the last point to the first one
		bezierPath.closePath()
		
		//If we have a fillColor, let's fill
		if let fillColor = self.fillColor {
			CGContextAddPath(context, bezierPath.CGPath)
			CGContextSetFillColorWithColor(context, fillColor.CGColor)
			CGContextFillPath(context)
		}
		
		//If we have a strokeColor, let's stroke
		if let strokeColor = self.strokeColor{
			CGContextSetStrokeColorWithColor(context, strokeColor.CGColor)
			CGContextSetLineWidth(context, lineWidth)
			CGContextAddPath(context, bezierPath.CGPath)
			CGContextStrokePath(context)
		}
	}
}
