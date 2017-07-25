//
//  mapViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-12.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Mapbox

class mapViewController: UIViewController, MGLMapViewDelegate {
    
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
        setupMap()
        view.addSubview(self.mapView)
        view.addSubview(showMyLocationButton)
        setupMyLocationButton()
        mapView.delegate = self
        drawTrailPathLine()
        drawTrailHeadPoint()
        drawPlacemarkPoint()
    }
    
    func flyTomyLocation(){
        guard let myLocation = self.mapView.userLocation?.location?.coordinate else { return }
        self.mapView.setCenter(myLocation,  zoomLevel: 14,animated: true)
    }
    
    func drawTrailPathLine() {
        // Parsing GeoJSON can be CPU intensive, do it on a background thread
        DispatchQueue.global(qos: .background).async(execute: {
            // Get the path for example.geojson in the app's bundle
            
            let jsonPath = Bundle.main.path(forResource: "trails", ofType: "geojson")
            let url = URL(fileURLWithPath: jsonPath!)
            
            do {
                // Convert the file contents to a shape collection feature object
                let data = try Data(contentsOf: url)
                let shapeCollectionFeature = try MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLShapeCollectionFeature
                for i in 0...((shapeCollectionFeature.shapes.count) - 1){
                    if let polyline = shapeCollectionFeature.shapes[i] as? MGLPolylineFeature {
                        // Optionally set the title of the polyline, which can be used for:
                        //  - Callout view
                        //  - Object identification
                        polyline.title = polyline.attributes["Name"] as? String
                        // Add the annotation on the main thread
                        DispatchQueue.main.async(execute: {
                            // Unowned reference to self to prevent retain cycle
                            [unowned self] in
                            self.mapView.addAnnotation(polyline)
                        })
                    }else{
                        let multipolyline = shapeCollectionFeature.shapes[i] as? MGLMultiPolylineFeature
                        print(multipolyline?.attributes["Name"] as! String)
                        for i in 0...((multipolyline?.polylines.count)! - 1){
                            DispatchQueue.main.async(execute: {
                                // Unowned reference to self to prevent retain cycle
                                [unowned self] in
                                self.mapView.addAnnotation((multipolyline?.polylines[i])!)
                            })
                        }
                    }
                
            }
            }
            catch {
                print("GeoJSON parsing failed")
            }
        })
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
    
    func drawPlacemarkPoint(){
        DispatchQueue.global(qos: .background).async(execute: {
            let jsonPath = Bundle.main.path(forResource: "point", ofType: "geojson")
            let url = URL(fileURLWithPath: jsonPath!)
            print(url)
            do{
                let data = try Data(contentsOf: url)
                print(data)
                let placemarkpointCollectionFeature = try MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLShapeCollectionFeature
                print(placemarkpointCollectionFeature.shapes.count)
                for i in 0...(placemarkpointCollectionFeature.shapes.count) - 1{
                    if let point = placemarkpointCollectionFeature.shapes[i]as? MGLPointFeature{
                        point.title = point.attribute(forKey: "NAME" ) as? String
                        
                        DispatchQueue.main.async(execute: {
                            // Unowned reference to self to prevent retain cycle
                            [unowned self] in
                            self.mapView.addAnnotation(point)
                        })
                    }
                }
            }catch{
                print(error.localizedDescription)
                print("GeoJSON parsing failed")
                
            }
            
        })
    }
    
    func setupMyLocationButton(){
        showMyLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        showMyLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72).isActive = true
        showMyLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showMyLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupMap(){
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 47.576769 , longitude: -52.731517), zoomLevel: 12, animated: false)
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 5
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if (annotation.title == "Signal Hill - North Head" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        }
        else
        {
            return .black

        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    
}
