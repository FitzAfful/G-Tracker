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
	let date: Date! = Date()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		mapView.tintColor = .lightGray
		mapView.zoomLevel = 10
		mapView.delegate = self
		self.title = channel.description
		
		var coordinates:[CLLocationCoordinate2D] = []
		
		// Fill an array with point annotations and add it to the map.
		var pointAnnotations = [MGLPointAnnotation]()
		for feed in self.channel.feeds {
			coordinates.append(CLLocationCoordinate2D(latitude: Double(feed.latitude)!, longitude: Double(feed.longitude)!))
		}
		
		for coordinate in coordinates {
			let point = MGLPointAnnotation()
			point.coordinate = CLLocationCoordinate2D(latitude: Double(coordinate.latitude), longitude: Double(coordinate.longitude))
			point.title = "\(point.coordinate.latitude), \(point.coordinate.longitude)"
			pointAnnotations.append(point)
		}
		
		if(!(coordinates.isEmpty)){
			mapView.centerCoordinate = CLLocationCoordinate2D(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude)
		}
		mapView.addAnnotations(pointAnnotations)
	}
	
	@IBAction func options() {
		let alert = UIAlertController(title: "Delete Vehicle", message: "Are you sure you want to delete vehicle?", preferredStyle: UIAlertController.Style.actionSheet)
		alert.addAction(UIAlertAction(title: "Yes, Delete", style: UIAlertAction.Style.destructive, handler: { (action) in
			RealmManager().deleteById(id: self.channel!.id)
			self.navigationController?.popToRootViewController(animated: true)
		}))
		alert.addAction(UIAlertAction(title: "No. Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	@IBAction func chooseDate() {
		let alert = UIAlertController(style: .actionSheet, title: "", message: "Choose Date to see route for car")
		alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil ) { date in
			print(date)
		}
		alert.addAction(title: "Done", style: .cancel)
		alert.show()
	}

	// Use the default marker. See also: our view annotation or custom marker examples.
	func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
		// This example is only concerned with point annotations.
		guard annotation is MGLPointAnnotation else {
			return nil
		}
		
		// Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
		let reuseIdentifier = "\(annotation.coordinate.longitude)"
		
		// For better performance, always try to reuse existing annotations.
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
		
		// If there’s no reusable annotation view available, initialize a new one.
		if annotationView == nil {
			annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
			annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
			
			// Set the annotation view’s background color to a value determined by its longitude.
			let hue = CGFloat(annotation.coordinate.longitude) / 100
			annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
		}
		
		return annotationView
	}
	
	// Allow callout view to appear when an annotation is tapped.
	func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
		return true
	}
}


//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Use CALayer’s corner radius to turn this view into a circle.
		layer.cornerRadius = bounds.width / 2
		layer.borderWidth = 2
		layer.borderColor = UIColor.white.cgColor
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Animate the border width in/out, creating an iris effect.
		let animation = CABasicAnimation(keyPath: "borderWidth")
		animation.duration = 0.1
		layer.borderWidth = selected ? bounds.width / 4 : 2
		layer.add(animation, forKey: "borderWidth")
	}
}
