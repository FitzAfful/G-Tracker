//
//  CarsController.swift
//  G-Tracker
//
//  Created by Paa Quesi Afful on 18/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class CarsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
	
	
	var channels:[Channel] = []
	var searchChannels:[Channel] = []
	var searched: Bool = false
	let gateway = RealmManager()
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var emptyView: UIView!
	let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchController.searchBar.placeholder = "Search Cars"
		searchController.searchResultsUpdater = self
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
		}
		self.tableView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: "ChannelCell")
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
		self.tableView.tableFooterView = UIView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		getData()
		if(channels.isEmpty){
			self.tableView.isHidden = true
			self.emptyView.isHidden = false
		}else{
			self.tableView.isHidden = false
			self.emptyView.isHidden = true
			tableView.reloadData()
		}
	}
	
	func getData(){
		self.channels.removeAll()
		self.channels = gateway.getAll()
		print(self.channels)
		setupChannels()
	}
	
	func setupChannels(){
		self.tableView.reloadData()
	}
	
	func searchMethod(searchText: String){
		searchChannels.removeAll()
		if(searchText.isEmpty){
			searched = false
			self.setupChannels()
			return
		}else if(searchController.isActive && !(searchText.isEmpty)){
			searchChannels = channels.filter({( channel : Channel) -> Bool in
				return (channel.name.lowercased().contains(searchText.lowercased()))
			})
			searched = true
			self.setupChannels()
		}
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		searchMethod(searchText: searchController.searchBar.text!)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchMethod(searchText: searchText)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 180.0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(searched){
			return searchChannels.count
		}
		return channels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
		if(searched){
			let channel = searchChannels[indexPath.row]
			cell.titleLabel.text = channel.description
			
			cell.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			if let lastFeed = self.searchChannels[indexPath.row].feeds.last {
				cell.mapView.setCenter(CLLocationCoordinate2D(latitude: Double(lastFeed.latitude)!, longitude: Double(lastFeed.longitude)!), zoomLevel: 12, animated: false)
				let hello = MGLPointAnnotation()
				hello.coordinate = CLLocationCoordinate2D(latitude: Double(lastFeed.latitude)!, longitude: Double(lastFeed.longitude)!)
				hello.title = "Last Seen"
				cell.mapView.addAnnotation(hello)
			}
			
			return cell
		}
		
		let channel = channels[indexPath.row]
		cell.titleLabel.text = channel.description
		if let lastFeed = self.channels[indexPath.row].feeds.last {
			cell.mapView.setCenter(CLLocationCoordinate2D(latitude: Double(lastFeed.latitude)!, longitude: Double(lastFeed.longitude)!), zoomLevel: 12, animated: false)
			let hello = MGLPointAnnotation()
			hello.coordinate = CLLocationCoordinate2D(latitude: Double(lastFeed.longitude)!, longitude: Double(lastFeed.longitude)!)
			hello.title = "Last Seen"
			cell.mapView.addAnnotation(hello)
		}
		return cell
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if(searched){
			let channel = self.searchChannels[indexPath.row]
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller:MapController = storyboard.instantiateViewController(withIdentifier: "MapController") as! MapController
			controller.channel = channel
			self.navigationController!.pushViewController(controller, animated: true)
			return
		}
		
		let channel = self.channels[indexPath.row]
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller:MapController = storyboard.instantiateViewController(withIdentifier: "MapController") as! MapController
		controller.channel = channel
		self.navigationController!.pushViewController(controller, animated: true)
	}
	
}
