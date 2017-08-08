//
//  mapViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-12.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Mapbox
import CoreMotion
import Firebase

class mapViewController: UIViewController {
    var userPathLayer: MGLStyleLayer?

    let statsView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "3ACFD5")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trailName : UILabel = {
        let label = UILabel()
        label.text = "text"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.text = "Distance: "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "Time: "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let stepsLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Steps: "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    let travelDistance : UILabel = {
        let label = UILabel()
        label.text = "1000m"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let travelTime : UILabel = {
        let label = UILabel()
        label.text = "0:00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let totalSteps : UILabel = {
        let label = UILabel()
        label.text = "0 steps"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    
    
    //session vars
    var time: String?
    var date : Date?
    var steps : Int = 0
    var distance: Double = 0
    var pastCheckPoint : String? = ""
    var trailID : String? = ""

    //the pedometer
    var pedometer = CMPedometer()
    
    // timers
    var timer = Timer()
    var timerInterval = 1.0
    var timeElapsed:TimeInterval = 1.0
    
    let locationManager = CLLocationManager()
    
    let searchController = UISearchController(searchResultsController: nil)
    var trailHeads = [Head]()
    var filterTrailHeads = [Head]()
    
    var placemarks = [Placemark]()
    var tempPlacemarks = [Placemark]()
    var activePlacemarks = [CLRegion]()
    var activeTrailheads = [CLRegion]()
    var allPlacemarks = [CLRegion]()
    var allLocations = [CLLocation]()
    
    var shortestDistance : Double!
    var locationName : String!
    
    //vars used for the notification system
    var readText = ""
    var lastIndex = -2
    var lastID = ""
    var activeSession = false
    
    //variables required for drawing in the map
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]! = []
    
    var tempCoordArray: [Any] = []
    
    
    var closestID : String?
    var closestLocation: CLLocation?
    
    
    var tempArray : [Session] = []
    

    //firebase vars
    var ref: DatabaseReference?

    
    var mapView: MGLMapView!
    
    lazy var showMyLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setImage(#imageLiteral(resourceName: "myLocation"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blue, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(flyTomyLocation), for: .touchUpInside)
        return button
    }()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 80
        locationManager.startUpdatingLocation()
        setupMap()
        view.addSubview(self.mapView)
        view.addSubview(showMyLocationButton)
        setupMyLocationButton()
        mapView.delegate = self
        drawTrailPathLine()
        drawTrailHeadPoint()
        drawPlacemarkPoint()
        
        fetchTrailHead()
        fetchPlacemarks()
        setupGeofencing()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if activeSession {
            setupStatView()
        }
        
     
    }
    
    
    
    func setupMyLocationButton(){
        showMyLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        showMyLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        showMyLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showMyLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    
    func startSession(){
        if !activeSession {
            setupStatView()
            activeSession = true
            setupSession()
            
        }
    
    }
    
    func stopSession(){
        if activeSession {

            activeSession = false
            statsView.removeFromSuperview()
            finishSession()
        }
   
    }

    func setupStatView(){
        
        view.addSubview(statsView)
        statsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        statsView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statsView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        statsView.heightAnchor.constraint(equalToConstant:120).isActive = true
        
        //trailName.text = trailProperties?.Name
        
        statsView.addSubview(trailName)
        statsView.addSubview(distanceLabel)
        statsView.addSubview(travelDistance)
        statsView.addSubview(timeLabel)
        statsView.addSubview(travelTime)
        statsView.addSubview(stepsLabel)
        statsView.addSubview(totalSteps)
        
        trailName.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 8).isActive = true
        trailName.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 8).isActive = true
        trailName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: trailName.bottomAnchor, constant: 14).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 16).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 4).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 16).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stepsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4).isActive = true
        stepsLabel.leftAnchor.constraint(equalTo: statsView.leftAnchor, constant: 16).isActive = true
        stepsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        travelDistance.leftAnchor.constraint(equalTo: stepsLabel.rightAnchor, constant: 20).isActive = true
        travelDistance.topAnchor.constraint(equalTo: trailName.bottomAnchor, constant: 14).isActive = true
        travelDistance.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        travelTime.leftAnchor.constraint(equalTo: stepsLabel.rightAnchor, constant: 20).isActive = true
        travelTime.topAnchor.constraint(equalTo: travelDistance.bottomAnchor, constant: 4).isActive = true
        travelTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        totalSteps.leftAnchor.constraint(equalTo: stepsLabel.rightAnchor, constant: 20).isActive = true
        totalSteps.topAnchor.constraint(equalTo: travelTime.bottomAnchor, constant: 4).isActive = true
        totalSteps.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }

}
