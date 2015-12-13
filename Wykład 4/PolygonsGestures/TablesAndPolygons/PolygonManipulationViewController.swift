//
//  PolygonManipulationViewController.swift
//  TablesAndPolygons
//
//  Created by Kajetan Dąbrowski on 07.12.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import UIKit

class PolygonManipulationViewController: UIViewController, UIGestureRecognizerDelegate
{
	weak var addPolygonGestureRecognizer: UITapGestureRecognizer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupGestureRecognizer()
	}
	
	private func setupGestureRecognizer() {
		let addPolygonGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("addPolygon:"))
		self.addPolygonGestureRecognizer = addPolygonGestureRecognizer
//		let twoFingerSwipeOnScreenGestureRecognizer = //TODO
		self.view.addGestureRecognizer(addPolygonGestureRecognizer)
	}
	
	func addPolygon(sender: UITapGestureRecognizer) -> Void {
		let polygonView: PolygonView = PolygonView()
		polygonView.numberOfSides = 4 + Int(arc4random())%10
		polygonView.center = sender.locationInView(self.view)
		polygonView.bounds = CGRectMake(0, 0, 200, 200)
		
		self.setupGesturesForPolygon(polygonView)
		
		self.view.addSubview(polygonView)
	}
	
	func setupGesturesForPolygon(polygonView: PolygonView) -> Void {
		let removeGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("polygonDoubleTapped:"))
		removeGestureRecognizer.numberOfTapsRequired = 2
		self.addPolygonGestureRecognizer?.requireGestureRecognizerToFail(removeGestureRecognizer)
		polygonView.addGestureRecognizer(removeGestureRecognizer)
		
		
		let pickupGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("polygonLongPressed:"))
		self.addPolygonGestureRecognizer?.requireGestureRecognizerToFail(pickupGestureRecognizer)
		polygonView.addGestureRecognizer(pickupGestureRecognizer)
		
		let rotationGestureRecognizer: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: Selector("polygonRotated:"))
		polygonView.addGestureRecognizer(rotationGestureRecognizer)
		rotationGestureRecognizer.delegate = self
		
		let pinchGestureRecognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("polygonPinched:"))
		polygonView.addGestureRecognizer(pinchGestureRecognizer)
		pinchGestureRecognizer.delegate = self
		
		let swipeLeftGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("polygonSwiped:"))
		let swipeRightGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("polygonSwiped:"))
		swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
		swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
		swipeLeftGestureRecognizer.delegate = self
		swipeRightGestureRecognizer.delegate = self
		polygonView.addGestureRecognizer(swipeLeftGestureRecognizer)
		polygonView.addGestureRecognizer(swipeRightGestureRecognizer)
	}
	
	func polygonDoubleTapped(sender: UITapGestureRecognizer) {
		sender.view?.removeFromSuperview()
	}
	
	func polygonLongPressed(sender: UILongPressGestureRecognizer) {
		//TODO: Fix snap to center
		switch sender.state {
		case .Began:
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				sender.view?.transform = CGAffineTransformScale(sender.view!.transform, 1.2, 1.2)
				sender.view?.alpha = 0.5
			})
		case .Changed:
			sender.view?.center = sender.locationInView(sender.view!.superview)
		case .Cancelled:
			fallthrough
		case .Ended:
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				sender.view?.transform = CGAffineTransformScale(sender.view!.transform, 1.0/1.2, 1.0/1.2)
				sender.view?.alpha = 1.0
			})
		case .Failed:
			break
		case .Possible:
			break
		}
	}
	
	func polygonRotated(sender: UIRotationGestureRecognizer) -> Void {
		//TODO
	}
	
	func polygonPinched(sender: UIPinchGestureRecognizer) -> Void {
		//TODO
	}
	
	func polygonSwiped(sender: UISwipeGestureRecognizer) -> Void {
		//Change number of sides
		if let senderPolygonView = sender.view as? PolygonView {
			let newNumberOfSides: Int = max(3, senderPolygonView.numberOfSides + (sender.direction == UISwipeGestureRecognizerDirection.Left ? -1 : 1))
			senderPolygonView.numberOfSides = newNumberOfSides
		}
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		//TODO
		return false
	}
}
