//
//  HymnCell.swift
//  Baptist Hymnal
//
//  Created by Fitzgerald Afful on 10/10/2018.
//  Copyright © 2018 Fitzgerald Afful. All rights reserved.
//

import UIKit
import Mapbox

class ChannelCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var mapView: MGLMapView!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		mapView.layer.cornerRadius = 15
		mapView.layer.shadowOpacity = 0.7
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	
}
