//
//  Channel.swift
//  G-Tracker
//
//  Created by Fitzgerald Afful on 18/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import Foundation
import RealmSwift

struct Channel: Decodable {
	
	var id: Int
	var name: String
	var description: String
	var latitude: String
	var longitude: String
	var created_at: String
	var last_entry_id: Int
	var feeds: [Feed] = []
	var channel_key: String = ""
	var secret_key: String = ""
	
	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case latitude
		case longitude
		case created_at
		case last_entry_id
	}
}

extension Channel: Equatable { }

func == (lhs: Channel, rhs: Channel) -> Bool {
	return lhs.id == rhs.id
}


public class RealmChannel: Object {
	@objc dynamic var id: Int = 0
	@objc dynamic var name: String = ""
	@objc dynamic var latitude: String = ""
	@objc dynamic var desc: String = ""
	@objc dynamic var longitude: String = ""
	@objc dynamic var created_at: String = ""
	@objc dynamic var last_entry_id: Int = 0
	@objc dynamic var channel_key: String = ""
	@objc dynamic var secret_key: String = ""
	
	var feeds = RealmSwift.List<RealmFeed>()
	
	convenience init(channel: Channel) {
		self.init()
		self.id = channel.id
		self.name = channel.name
		self.desc = channel.description
		self.longitude = channel.longitude
		self.latitude = channel.latitude
		self.created_at = channel.created_at
		self.channel_key = channel.channel_key
		self.secret_key = channel.secret_key
		self.last_entry_id = channel.last_entry_id
		for item in channel.feeds{
			self.feeds.append(RealmFeed(feed: item))
		}
	}
	
	override public static func primaryKey() -> String? {
		return "id"
	}
	
	var channel: Channel{
		var feedz : [Feed] = []
		for item in feeds {
			let feed = item.feed
			feedz.append(feed)
		}
		
		return Channel(id: id, name: name, description: desc, latitude: latitude, longitude: longitude, created_at: created_at, last_entry_id: last_entry_id, feeds: feedz, channel_key: channel_key, secret_key: secret_key)
	}
}
