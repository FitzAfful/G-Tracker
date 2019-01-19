//
//  Channel.swift
//  G-Tracker
//
//  Created by Fitzgerald Afful on 18/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import Foundation

struct ThingSpeakResponse: Decodable {
	
	var channel: Channel
	var feeds: [Feed]
	
	private enum CodingKeys: String, CodingKey {
		case channel
		case feeds
	}
}

