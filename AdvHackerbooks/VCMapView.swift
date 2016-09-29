//
//  VCMapView.swift
//  AdvHackerbooks
//
//  Created by jro on 30/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import MapKit

extension UIViewController: MKMapViewDelegate {
    
    // 1
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Localization {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
                
            }
            return view
        }
        return nil
    }
}
