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
	var routeLine: MGLPolyline!
	var pointAnnotations = [MGLPointAnnotation]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		mapView.tintColor = .lightGray
		mapView.zoomLevel = 10
		mapView.delegate = self
		self.title = channel.name
		self.plotOnMap(feeds: self.channel.feeds)
		
	}
	
	
	func plotOnMap(feeds: [Feed]){
		if(routeLine != nil){
			mapView.removeAnnotation(routeLine)
		}
		if(!(pointAnnotations.isEmpty)){
			mapView.removeAnnotations(pointAnnotations)
		}
		var coordinates:[CLLocationCoordinate2D] = []
		for feed in feeds {
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
		
		
		routeLine = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
		mapView.addAnnotation(routeLine)
		mapView.setVisibleCoordinates(&coordinates, count: UInt(coordinates.count), edgePadding: .zero, animated: true)
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
		print("choose From")
		var myDate: Date! = Date()
		let alert = UIAlertController(style: .actionSheet, title: "Choose Start Date", message: "Choose Start Date to see route for car")
		alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date() ) { date2 in
			print("choose From 1")
			myDate = date2
		}
		alert.addAction(UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: { (action) in
			self.chooseTo(oldDate: myDate)
		}))
		alert.addAction(title: "Cancel", style: .cancel)
		self.navigationController?.present(alert, animated: true, completion: nil)
	}
	
	func chooseTo(oldDate: Date){
		var newDate: Date = Date()
		let alert1 = UIAlertController(style: .actionSheet, title: "Choose End Date", message: "Choose End Date to see route for car")
		alert1.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date() ) { date1 in
			print("choose From 2")
			newDate = date1
		}
		alert1.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (action) in
			var myFeeds: [Feed] = []
			for item in self.channel.feeds {
				let dateFormatter = DateFormatter()
				dateFormatter.locale = Locale.current
				dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
				
				if let feedDate = dateFormatter.date(from: item.created_at) {
					if((feedDate > oldDate) && (feedDate < newDate)){
						myFeeds.append(item)
					}
				}
			}
			self.plotOnMap(feeds: myFeeds)
		}))
		alert1.addAction(title: "Cancel", style: .cancel)
		self.navigationController?.present(alert1, animated: true, completion: nil)
	}
	
	@IBAction func chooseByPoints(_ sender: Any){
		let alert = UIAlertController(style: .actionSheet, title: "Picker View", message: "Preferred Content Height")
			
		let frameSizes: [CGFloat] = (1...self.channel.feeds.count).map { CGFloat($0) }
		let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
		let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
			
		var number = ""
		alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
			let item = values[0]
			print(item[index.row])
			number = item[index.row]
		}
		alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (action) in
			print("Number: \(number)")
			let myFeeds = self.channel.feeds.prefix(Int(number) ?? 0)
			self.plotOnMap(feeds: Array(myFeeds))
		}))
		self.navigationController?.present(alert, animated: true, completion: nil)
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
			//annotationView = MGLAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
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
