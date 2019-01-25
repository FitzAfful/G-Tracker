//
//  RealmManager.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 18/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import Foundation

//
//  LocalPersistenceChannelsGateway.swift
//  Aftown
//
//  Created by Fitzgerald Afful on 04/01/2018.
//  Copyright © 2018 Aftown. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

typealias FetchChannelEntityGatewayCompletionHandler = (_ artist: Result<Channel>) -> Void

class RealmManager {
	func fetchChannel(channelParameter: String, completionHandler: @escaping FetchChannelEntityGatewayCompletionHandler) {
		
	}
	
	var realm = try! Realm()
	init() {
		realm = try! Realm()
	}
	
	func getAll() -> [Channel] {
		return realm.objects(RealmChannel.self).map { $0.channel }
	}
	
	func getById(id: String) -> Channel {
		return (realm.object(ofType: RealmChannel.self, forPrimaryKey: Int.self)?.channel)!
	}
	
	func getRealmChannelById(id: Int) -> RealmChannel {
		return realm.object(ofType: RealmChannel.self, forPrimaryKey: id)!
	}
	
	func save(channel: Channel) {
		try! realm.write {
			realm.add(RealmChannel(channel: channel), update: true)
		}
	}
	
	func clean() {
		try! realm.write {
			realm.delete(realm.objects(RealmChannel.self))
		}
	}
	
	func deleteById(id: Int) {
		print("ghghgh000")
		let object = getRealmChannelById(id: id)
		print("ghghgh")
		try! realm.write {
			realm.delete(object )
		}
	}
	
	// MARK: - ChannelsGateway
	
	func fetchChannels(completionHandler: @escaping (Result<[Channel]>) -> Void) {
		print("Realm Fetch Channeles")
		let channels = realm.objects(RealmChannel.self).map { $0.channel }.sorted { (a,b) -> Bool in
			return true
		}
		completionHandler(.success(channels))
	}
	
	// MARK: - LocalPersistenceChannelsGateway
	func save(channels: [Channel]) {
		var realmChannels : [RealmChannel] = []
		for channel in channels {
			realmChannels.append(RealmChannel(channel: channel))
		}
		try! realm.write {
			realm.add(realmChannels, update: true)
		}
	}
	
}
