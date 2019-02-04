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
		self.title = channel.name
		
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
		let alert = UIAlertController(title: "Options", message: "", preferredStyle: UIAlertController.Style.actionSheet)
		alert.addAction(UIAlertAction(title: "Edit Vehicle Details", style: UIAlertAction.Style.default, handler: { (action) in
			let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let slideController = myStoryboard.instantiateViewController(withIdentifier: "EditCarController") as! EditCarController
			slideController.channel = self.channel
			self.navigationController!.pushViewController(slideController, animated: true)
		}))
		alert.addAction(UIAlertAction(title: "Delete Vehicle", style: UIAlertAction.Style.destructive, handler: { (action) in
			let alert1 = UIAlertController(title: "Delete Vehicle", message: "Are you sure you want to delete vehicle?", preferredStyle: UIAlertController.Style.actionSheet)
			alert1.addAction(UIAlertAction(title: "Yes, Delete", style: UIAlertAction.Style.destructive, handler: { (action) in
				RealmManager().deleteById(id: self.channel!.id)
				self.navigationController?.popToRootViewController(animated: true)
			}))
			alert1.addAction(UIAlertAction(title: "No. Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
				alert1.dismiss(animated: true, completion: nil)
			}))
			self.present(alert1, animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	@IBAction func chooseFrom(_ sender: Any) {
		let alert = UIAlertController(style: .actionSheet, title: "Choose Start Date", message: "Choose Start Date to see route for car")
		alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil ) { date in
			let alert1 = UIAlertController(style: .actionSheet, title: "Choose End Date", message: "Choose End Date to see route for car")
			alert1.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil ) { date in
				//Check the range here
			}
			alert1.addAction(title: "Done", style: .cancel)
			alert1.show()
		}
		alert.addAction(title: "Done", style: .cancel)
		alert.show()
	}
	
	@IBAction func chooseByPoints(_ sender: Any){
		let alert = UIAlertController(style: .actionSheet, title: "TextField", message: "Secure Entry")
		
		let textField: TextField.Config = { textField in
			textField.leftViewPadding = 12
			textField.becomeFirstResponder()
			textField.borderWidth = 1
			textField.cornerRadius = 8
			textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
			textField.backgroundColor = nil
			textField.textColor = .black
			textField.placeholder = "Type Number of Points"
			textField.keyboardAppearance = .default
			textField.keyboardType = .numberPad
			//textField.isSecureTextEntry = true
			textField.returnKeyType = .done
			textField.action { textField in
				//Log("textField = \(String(describing: textField.text))")
			}
		}
		
		alert.addOneTextField(configuration: textField)
		alert.addAction(title: "OK", style: .cancel)
		delay(1) {
			alert.show()
		}
		print("Kofi attah")
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


func delay(_ delay:Double, closure:@escaping ()->()) {
	DispatchQueue.main.asyncAfter(
		deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
