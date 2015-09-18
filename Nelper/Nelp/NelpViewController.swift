//
//  NelpViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import Stripe

class NelpViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, FilterSortViewControllerDelegate{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var nelperTitle: UILabel!
	
	@IBOutlet weak var entireContainer: UIView!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var mapViewContainer: UIView!
	
	
	@IBOutlet weak var tableViewContainer: UIView!
	
	@IBOutlet weak var centerButton: UIButton!
	
	@IBOutlet weak var tabView: UIView!
	@IBOutlet weak var nelpTabBarImage: UIButton!
	@IBOutlet weak var findNelpTabBarImage: UIButton!
	@IBOutlet weak var profileTabBarImage: UIButton!
	
	var tableView: UITableView!
	var refreshView: UIRefreshControl!
	
	var nelpTasks = [NelpTask]()
	var findNelpTasks = [FindNelpTask]()
	
	var mapView: MKMapView!
	var currentLocation: CLLocation?
	var placesClient: GMSPlacesClient?
	let locationManager = CLLocationManager()
	var target: CLLocationCoordinate2D?
	
	var arrayOfFilters = Array<String>()
	var sortBy: String?
	var minPrice: Double?
	var maxDistance: Double?
	
	//MARK: Initialization
	
	convenience init() {
		self.init(nibName: "NelpViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		placesClient = GMSPlacesClient()
		self.adjustUI()
		self.initializeMapview()
		self.createTaskTableView()
		self.loadData()
		self.extendedLayoutIncludesOpaqueBars = true
	}

	override func viewDidAppear(animated: Bool) {
		if self.arrayOfFilters.isEmpty && self.sortBy == nil && self.minPrice == nil && self.maxDistance == nil {
				self.loadData()
		}
	}
	
	//MARK: Creating the View
	
 /**
	Creates the view
	*/
	
	func createTaskTableView(){
		let tableView = UITableView()
		self.tableView = tableView
		self.tableView.delegate = self
		self.tableView.dataSource = self
		tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableView.registerClass(NelpViewCell.classForCoder(), forCellReuseIdentifier: NelpViewCell.reuseIdentifier)
		self.tableView.backgroundColor = whiteNelpyColor

		let refreshView = UIRefreshControl()
		refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshView)
		
		self.tableViewContainer.addSubview(tableView)
		
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tableViewContainer.snp_edges)
		}
		self.refreshView = refreshView
		
		//Filters
		
		var filtersButton = UIButton()
		self.navBar.addSubview(filtersButton)
		filtersButton.setTitle("Filters", forState: UIControlState.Normal)
		filtersButton.setTitleColor(nelperRedColor, forState: UIControlState.Normal)
		filtersButton.addTarget(self, action: "didTapFiltersButton:", forControlEvents: UIControlEvents.TouchUpInside)
		filtersButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(navBar.snp_right).offset(-4)
			make.centerY.equalTo(navBar.snp_centerY).offset(4)
		}
	}
	
	/**
	Creates and sets the MapView
	
	- returns: void
	*/
	func initializeMapview(){
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 40
		
		var mapview = MKMapView()
		
		self.mapView = mapview;
		
		self.mapViewContainer.addSubview(mapview)
		self.mapView.showsUserLocation = true
		
		if((self.locationManager.location) != nil){
			var userLocation: CLLocation = self.locationManager.location!
			self.currentLocation = userLocation
			LocationHelper.sharedInstance.currentLocation = PFGeoPoint(latitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
			var userLocationForCenter = userLocation.coordinate
			var span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
			var locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
			self.mapView.setRegion(locationToZoom, animated: true)
			self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		}
		mapview.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapViewContainer.snp_edges)
		}
		
	}
	
	//MARK: UI
	
	func adjustUI(){
		self.entireContainer.backgroundColor = grayDetails
		self.container.backgroundColor = grayDetails
		self.navBar.setTitle("Browse Tasks")
	}
	
	func createPins(){
		
		for task in self.nelpTasks {
			let taskPin = MKPointAnnotation()
			if(task.location != nil) {
				let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(task.location!.latitude, task.location!.longitude)
				taskPin.coordinate = location
				self.mapView.addAnnotation(taskPin)
				
			}
		}
	}
	
	
	//MARK: DATA
	
 /**
	Reload Data on pullToRefresh
	*/
	
	func onPullToRefresh() {
		if self.arrayOfFilters.isEmpty && self.sortBy == nil && self.minPrice == nil && self.maxDistance == nil {
			self.loadData()
		} else{
			self.loadDataWithFilters(self.arrayOfFilters, sort: self.sortBy, minPrice: self.minPrice, maxDistance: self.maxDistance)
		}
	}
	
	/**
	Fetches the required date from Backend
	*/
	func loadData() {
		ApiHelper.listNelpTasksWithBlock(nil, sortBy: nil, minPrice: nil, maxDistance: nil, block: {(nelpTasks: [NelpTask]?, error: NSError?) -> Void in
			if error != nil {
				
			} else {
				self.nelpTasks = nelpTasks!
				self.createPins()
				self.refreshView?.endRefreshing()
				self.tableView?.reloadData()
			}
		})
	}
	
	
	/**
	Loads Data matching the applied filters
	
	- parameter filters:     The Applied Filters
	- parameter sort:        The Sorting method
	- parameter minPrice:    Minimum Price Filter Value
	- parameter maxDistance: Maximum Distance Filter Value
	*/
	func loadDataWithFilters(filters:Array<String>?, sort:String?, minPrice:Double?, maxDistance:Double?){
		ApiHelper.listNelpTasksWithBlock(filters, sortBy: sort,minPrice:minPrice, maxDistance:maxDistance, block: {(nelpTasks: [NelpTask]?, error: NSError?) -> Void in
			if error != nil {
				
			} else {
				self.nelpTasks = nelpTasks!
				self.createPins()
				self.refreshView?.endRefreshing()
				self.tableView?.reloadData()
			}
		})
		
	}
	
	//MARK: Table View Data Source and Delegate
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.nelpTasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = self.tableView.dequeueReusableCellWithIdentifier(NelpViewCell.reuseIdentifier, forIndexPath: indexPath) as! NelpViewCell
		
		let nelpTask = self.nelpTasks[indexPath.item]
		cell.setNelpTask(nelpTask)
		cell.setImages(nelpTask)
		
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let selectedTask = self.nelpTasks[indexPath.row]
		let vc = NelpTasksDetailsViewController(nelpTask: selectedTask)
		self.presentViewController(vc, animated: false, completion: nil)
		
	}
	

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	
	
	//MARK: Location Delegate
	
	func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
		CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
			if error != nil{
				print("Error:" + error!.localizedDescription)
				return
				//fuck
			}else {
				print("worked")
			}
			
		})
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
//		var userLocation: CLLocation = self.locationManager.location
//		self.currentLocation = userLocation
//		var userLocationForCenter = userLocation.coordinate
//		var span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
//		var locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
//		self.mapView.setRegion(locationToZoom, animated: true)
//		self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		
		if self.currentLocation != nil{
		LocationHelper.sharedInstance.currentLocation = PFGeoPoint(latitude:self.currentLocation!.coordinate.latitude, longitude:self.currentLocation!.coordinate.longitude)
		}
		
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Error:" + error.localizedDescription)
	}
	
	
	/**
	Zoom on the users location
	
	- parameter userLocation: the location (user's) to zoom on
	*/
	func zoomToUserLocation (userLocation: CLLocation){
		let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
		let locationToZoom: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
		
	}
	
	
	//MARK: Filters Delegate
	
	/**
	Called when Filters are added by users
	
	- parameter filters:     Filters to apply
	- parameter sort:        Sorting to apply
	- parameter minPrice:    Minimum Price Filter Value
	- parameter maxDistance: Maximum Distance filter value
	*/
	func didTapAddFilters(filters: Array<String>?, sort: String?, minPrice:Double?, maxDistance:Double?){
		self.arrayOfFilters = filters!
		self.sortBy = sort
		print(filters!, terminator: "")
		self.minPrice = minPrice
		self.maxDistance = maxDistance
		self.loadDataWithFilters(filters, sort: sort, minPrice: minPrice, maxDistance: maxDistance)
	}
	
	//MARK: Actions
	
	@IBAction func centerMapOnUser(sender: AnyObject) {
		
	}
	
	func didTapFiltersButton(sender:UIButton){
		let nextVC =  FilterSortViewController()
		nextVC.arrayOfFiltersFromPrevious = self.arrayOfFilters
		nextVC.previousSortBy = self.sortBy
		nextVC.delegate = self
		nextVC.previousMinPrice = self.minPrice
		nextVC.previousMaxDistance = self.maxDistance
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	
	
	
}

