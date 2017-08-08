//
//  mapController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//


import UIKit
import Mapbox
import CoreMotion
import Firebase

extension mapViewController : MGLMapViewDelegate {
    
    func setupMap(){
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.setCenter(CLLocationCoordinate2D(latitude: 47.576769 , longitude: -52.731517), zoomLevel: 12, animated: false)
        
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
        return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    
    // Wait until the map is loaded before adding to the map.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        //addLayer(to: style)
    }
    
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
                        //print(multipolyline?.attributes["Name"] as! String)
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
            do{
                let data = try Data(contentsOf: url)
                let placemarkpointCollectionFeature = try MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLShapeCollectionFeature
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
}
