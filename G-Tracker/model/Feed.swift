//
//  Feed.swift
//  G-Tracker
//
//  Created by Fitzgerald Afful on 18/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import Foundation
import RealmSwift

struct Feed: Decodable  {
	
	var entry_id: Int
	var latitude: String //field1
	var longitude: String //field2
	var velocity: String //field3
	var altitude: String //field4
	var main_id: String //field5
	var sub_id: String //field6
	
	private enum CodingKeys: String, CodingKey {
		case entry_id
		case latitude = "field1"
		case longitude = "field2"
		case velocity = "field3"
		case altitude = "field4"
		case main_id = "field5"
		case sub_id = "field6"
	}
}

extension Feed: Equatable { }

func == (lhs: Feed, rhs: Feed) -> Bool {
	return lhs.entry_id == rhs.entry_id
}



public class RealmFeed: Object {
	@objc dynamic var entry_id: Int = 0
	@objc dynamic var latitude: String = ""
	@objc dynamic var longitude: String = ""
	@objc dynamic var velocity: String = ""
	@objc dynamic var altitude: String = ""
	@objc dynamic var main_id: String = ""
	@objc dynamic var sub_id: String = ""
	
	convenience init(feed: Feed) {
		self.init()
		self.entry_id = feed.entry_id
		self.latitude = feed.latitude
		self.longitude = feed.longitude
		self.velocity = feed.velocity
		self.altitude = feed.altitude
		self.main_id = feed.main_id
		self.sub_id = feed.sub_id
		
	}
	
	override public static func primaryKey() -> String? {
		return "entry_id"
	}
	
	var feed: Feed{
		return Feed(entry_id: self.entry_id, latitude: self.latitude, longitude: self.longitude, velocity: self.velocity, altitude: self.altitude, main_id: self.main_id, sub_id: self.sub_id)
	}
}
