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

class mapViewController: UIViewController, MGLMapViewDelegate {
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
    var trailN : String? = ""

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
    var icon: UIImage!
    var popup: UILabel?
    
    lazy var showMyLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.setImage(#imageLiteral(resourceName: "myLocation"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blue, for: UIControlState())
        button.addTarget(self, action: #selector(flyTomyLocation), for: .touchUpInside)
        return button
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icon = UIImage(named: "trail_sign_fill")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 80
        locationManager.startUpdatingLocation()
        setupMap()
        view.addSubview(self.mapView)
        view.addSubview(showMyLocationButton)
        setupMyLocationButton()
        mapView.delegate = self
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
    
    // Wait until the map is loaded before adding to the map.
//    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        //addLayer(to: style)
//    }
//    
    func updateLocationLine() {
        if allCoordinates.count > 0 {
            // Update our MGLShapeSource with the current locations.
            updatePolylineWithCoordinates(coordinates: allCoordinates)
        }
        
    }
    
    func addLayer(to style: MGLStyle) {
        // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        
        // Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
        layer.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
        layer.lineColor = MGLStyleValue(rawValue: UIColor.red)
        layer.lineWidth = MGLStyleFunction(interpolationMode: .exponential,
                                           cameraStops: [14: MGLConstantStyleValue<NSNumber>(rawValue: 5),
                                                         18: MGLConstantStyleValue<NSNumber>(rawValue: 20)],
                                           options: [.defaultValue : MGLConstantStyleValue<NSNumber>(rawValue: 1.5)])
        style.addLayer(layer)
        self.userPathLayer = layer
    }
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }
    
    func flyTomyLocation(){
        guard let myLocation = self.mapView.userLocation?.location?.coordinate else { return }
        self.mapView.setCenter(myLocation,  zoomLevel: 14,animated: true)
    }
    
    
    func drawPathLineCollection(data: Data){
        guard let style = self.mapView.style else { return }
        
        // Use [MGLShape shapeWithData:encoding:error:] to create a MGLShapeCollectionFeature from GeoJSON data.
        let feature = try! MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLShapeCollectionFeature
        
        // Create source and add it to the map style.
        let source = MGLShapeSource(identifier: "path", shape: feature, options: nil)
        style.addSource(source)
        
        // Create station style layer.
        

        // Create line style layer.
        let lineLayer = MGLLineStyleLayer(identifier: "trail-line", source: source)
        
        // Use a predicate to filter out the stations.
        lineLayer.lineColor = MGLStyleValue(rawValue: UIColor(hex:"557BE2"))
        lineLayer.lineWidth = MGLStyleValue(rawValue: 4)
        
        // Add style layers to the map view's style.
        style.addLayer(lineLayer)
        
    }
    
    func drawTrailHeadPoint(){
        DispatchQueue.global(qos: .background).async(execute: {
            let jsonPath = Bundle.main.path(forResource: "head", ofType: "geojson")
            let url = URL(fileURLWithPath: jsonPath!)
            do{
                let data = try Data(contentsOf: url)
                let pointCollectionFeature = try MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLShapeCollectionFeature
                for i in 0...(pointCollectionFeature.shapes.count) - 1{
                    if let point = pointCollectionFeature.shapes[i]as? MGLPointFeature{
                        point.title = point.attribute(forKey: "Name" ) as? String
                        DispatchQueue.main.async(execute: {

                            [unowned self] in
                            self.mapView.addAnnotation(point)
                        })
                    }

            }
            }catch{
                print("GeoJSON parsing failed")
                
            }
        })
    }
    

    
    func setupMyLocationButton(){
        showMyLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        showMyLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64).isActive = true
        showMyLocationButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        showMyLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func setupMap(){
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.setCenter(CLLocationCoordinate2D(latitude: 47.576769 , longitude: -52.731517), zoomLevel: 12, animated: true)

    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "trails", withExtension: "geojson") else { return }
            
            let data = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.drawPathLineCollection(data: data)
                self.drawClusterPlacemark(style: style)
            }
            
            self.drawTrailHeadPoint()

        }

    }
    
    //custom annotation image
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "trailHead")
        
        if annotationImage == nil {
            var image = UIImage(named: "trail_sign_fill_green")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "trailHead")
        }
        
        return annotationImage
    }
    
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        showPopup(false, animated: false)
    }
    
    func handleTap(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            let point = tap.location(in: tap.view)
            let width = icon.size.width
            let rect = CGRect(x: point.x - width / 2, y: point.y - width / 2, width: width, height: width)
            
            let clusters = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["clusteredPlacemarks"])
            let placemarks = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["placemark"])
            
            if clusters.count > 0 {
                showPopup(false, animated: true)
                let cluster = clusters.first!
                mapView.setCenter(cluster.coordinate, zoomLevel: (mapView.zoomLevel + 1), animated: true)
            } else if placemarks.count > 0 {
                let placemark = placemarks.first!
                
                if popup == nil {
                    popup = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
                    popup!.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                    popup!.layer.cornerRadius = 4
                    popup!.layer.masksToBounds = true
                    popup!.textAlignment = .center
                    popup!.lineBreakMode = .byTruncatingTail
                    popup!.font = UIFont.systemFont(ofSize: 16)
                    popup!.textColor = UIColor.black
                    popup!.alpha = 0
                    view.addSubview(popup!)
                }
                
                popup!.text = (placemark.attribute(forKey: "NAME")! as! String)
                let size = (popup!.text! as NSString).size(attributes: [NSFontAttributeName: popup!.font])
                popup!.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: -10, dy: -10)
                let point = mapView.convert(placemark.coordinate, toPointTo: mapView)
                popup!.center = CGPoint(x: point.x, y: point.y - 50)
                
                if popup!.alpha < 1 {
                    showPopup(true, animated: true)
                }
            } else {
                showPopup(false, animated: true)
            }
        }
    }
    
    func showPopup(_ shouldShow: Bool, animated: Bool) {
        let alpha: CGFloat = (shouldShow ? 1 : 0)
        if animated {
            UIView.animate(withDuration: 0.25) { [unowned self] in
                self.popup?.alpha = alpha
            }
        } else {
            popup?.alpha = alpha
        }
    }
    
    func drawClusterPlacemark(style: MGLStyle){
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "point", ofType: "geojson")!)
        
        let source = MGLShapeSource(identifier: "clusteredPlacemarks", url: url, options: [.clustered: true, .clusterRadius: icon.size.width])
        
        style.addSource(source)
        
        // Use a template image so that we can tint it with the `iconColor` runtime styling property.
        style.setImage(icon.withRenderingMode(.alwaysTemplate), forName: "trail_sign_fill")
        
        // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled source features.
        let placemarks = MGLSymbolStyleLayer(identifier: "placemark", source: source)
        placemarks.iconImageName = MGLStyleValue(rawValue: "trail_sign_fill")
        placemarks.iconColor = MGLStyleValue(rawValue: UIColor(hex:"AC7B56").withAlphaComponent(1))
        placemarks.predicate = NSPredicate(format: "%K != YES", "cluster")
        style.addLayer(placemarks)
        
        // Color clustered features based on clustered point counts.
        let stops = [
            5:  MGLStyleValue(rawValue: UIColor.darkGray),
            15:  MGLStyleValue(rawValue: UIColor.orange),
            20: MGLStyleValue(rawValue: UIColor.red),
            50: MGLStyleValue(rawValue: UIColor.purple)
        ]
        
        // Show clustered features as circles. The `point_count` attribute is built into clustering-enabled source features.
        let circlesLayer = MGLCircleStyleLayer(identifier: "clusteredPlacemarks", source: source)
        circlesLayer.circleRadius = MGLStyleValue(rawValue: NSNumber(value: Double(icon.size.width) / 2))
        circlesLayer.circleOpacity = MGLStyleValue(rawValue: 0.75)
        circlesLayer.circleStrokeColor = MGLStyleValue(rawValue: UIColor.white.withAlphaComponent(0.9))
        circlesLayer.circleStrokeWidth = MGLStyleValue(rawValue: 2)
        circlesLayer.circleColor = MGLSourceStyleFunction(interpolationMode: .interval,stops: stops,attributeName: "point_count",options: nil)
        circlesLayer.predicate = NSPredicate(format: "%K == YES", "cluster")
        style.addLayer(circlesLayer)
        
        // Label cluster circles with a layer of text indicating feature count. Per text token convention, wrap the attribute in {}.
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredplacemarksNumbers", source: source)
        numbersLayer.textColor = MGLStyleValue(rawValue: UIColor.white)
        numbersLayer.textFontSize = MGLStyleValue(rawValue: NSNumber(value: Double(icon.size.width) / 2))
        numbersLayer.iconAllowsOverlap = MGLStyleValue(rawValue: true)
        numbersLayer.text = MGLStyleValue(rawValue: "{point_count}")
        numbersLayer.predicate = NSPredicate(format: "%K == YES", "cluster")
        style.addLayer(numbersLayer)
        
        // Add a tap gesture for zooming in to clusters or showing popups on individual features.
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    func startSession(){
        if !activeSession {
            setupStatView()
            activeSession = true
            setupSession()
            guard let myLocation = self.mapView.userLocation?.location?.coordinate else { return }
            self.mapView.setCenter(myLocation,  zoomLevel: 15,animated: true)
            self.mapView.maximumZoomLevel = 16

            
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
        statsView.heightAnchor.constraint(equalToConstant:140).isActive = true
        
        statsView.addSubview(trailName)
        statsView.addSubview(distanceLabel)
        statsView.addSubview(travelDistance)
        statsView.addSubview(timeLabel)
        statsView.addSubview(travelTime)
        statsView.addSubview(stepsLabel)
        statsView.addSubview(totalSteps)
        
        trailName.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 20).isActive = true
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
