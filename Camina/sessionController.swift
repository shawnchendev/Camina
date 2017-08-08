//
//  sessionController.swift
//  Camina
//
//  Created by Diego Zuluaga on 2017-08-07.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import Foundation
import Mapbox

extension sessionView {
    
    
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
                        if polyline.attributes["ParkID"] as? String != self.trailProperties?.ParkID {
                            continue
                        }
                        polyline.title = polyline.attributes["Name"] as? String
                        // Add the annotation on the main thread
                        DispatchQueue.main.async(execute: {
                            // Unowned reference to self to prevent retain cycle
                            [unowned self] in
                            self.mapView.addAnnotation(polyline)
                        })
                    }else{
                        let multipolyline = shapeCollectionFeature.shapes[i] as? MGLMultiPolylineFeature
                        if multipolyline?.attributes["ParkID"] as? String != self.trailProperties?.ParkID {
                            continue
                        }
                        multipolyline?.title = multipolyline?.attributes["Name"] as? String
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
    
}
