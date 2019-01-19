//
//  HymnCell.swift
//  Baptist Hymnal
//
//  Created by Fitzgerald Afful on 10/10/2018.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit
import Mapbox

class ChannelCell: UITableViewCell, MGLMapViewDelegate{

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var mapView: MGLMapView!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
		mapView.delegate = self
		mapView.layer.cornerRadius = 15
		mapView.layer.shadowOpacity = 0.7
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
