//
//  PolygonView.swift
//  PolygonDrawing
//
//  Created by Kajetan Dąbrowski on 08.11.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import UIKit

protocol PolygonViewDataSource: class
{
	func numberOfVerticesInPolygonView(polygonView: PolygonView) -> Int
	func polygonView(polygonView: PolygonView, unarCoordinatedsForVertexAtIndex vertexIndex: Int) -> CGPoint
}

class PolygonView: UIView
{
	weak var dataSource: PolygonViewDataSource?
	
	var strokeColor: UIColor? {
		didSet {
			//color changed - we need to redraw
			self.setNeedsDisplay()
		}
	}
	
	var fillColor: UIColor? {
		didSet {
			//color changed - we need to redraw
			self.setNeedsDisplay()
		}
	}
	
	var lineWidth: CGFloat = 0.0 {
		didSet {
			//stroke changed - we need to redraw
			self.setNeedsDisplay()
		}
	}
	
	override func drawRect(rect: CGRect) {
		//guard let - coś jak if-let, ale w drugą stronę
		guard let dataSource = self.dataSource else {
			//There is no data source – there is nothing to draw
			return
		}
		
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
		
		for vertexIndex in 0..<dataSource.numberOfVerticesInPolygonView(self) {
			let coordinatesInUnarSpace: CGPoint = dataSource.polygonView(self, unarCoordinatedsForVertexAtIndex: vertexIndex)
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
