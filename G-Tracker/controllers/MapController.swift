//
//  MapController.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 18/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import UIKit
import Mapbox

class MapController: UIViewController, MGLMapViewDelegate {

	@IBOutlet weak var mapView: MGLMapView!
	var channel: Channel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.title = channel.description
		if let lastFeed = self.channel.feeds.last {
			mapView.setCenter(CLLocationCoordinate2D(latitude: Double(lastFeed.latitude)!, longitude: Double(lastFeed.longitude)!), zoomLevel: 12, animated: false)
			let hello = MGLPointAnnotation()
			hello.coordinate = CLLocationCoordinate2D(latitude: Double(lastFeed.longitude)!, longitude: Double(lastFeed.longitude)!)
			hello.title = "Last Seen"
			self.mapView.addAnnotation(hello)
		}
	}

	// Use the default marker. See also: our view annotation or custom marker examples.
	func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
		return nil
	}
	
	// Allow callout view to appear when an annotation is tapped.
	func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
		return true
	}
}
