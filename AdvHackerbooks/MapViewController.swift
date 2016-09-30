//
//  MapViewController.swift
//  AdvHackerbooks
//
//  Created by jro on 28/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var longitudeView: UILabel!
    @IBOutlet weak var latitudeView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    let loc : Localization?
    
    // set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000
    
    
    //MARK - Initializers
    init(withLocalization localization: Localization?){
        self.loc = localization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressView.isUserInteractionEnabled = false
        self.longitudeView.isUserInteractionEnabled = false
        self.latitudeView.isUserInteractionEnabled = false
        
        mapView.delegate = self

        // Do any additional setup after loading the view.
        synchronizeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func synchronizeView(){
        if let loc = self.loc {
            longitudeView.text = loc.longitude.description
            latitudeView.text = loc.latitude.description
            addressView.text = loc.locationName?.description
            let location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
            centerMapOnLocation(location: location)
            
            mapView.addAnnotation(self.loc!)
        }else{
            longitudeView.text = "Not Available"
            latitudeView.text = "Not Available"
            addressView.text = "Not Available"
             centerMapOnLocation(location: initialLocation)
        }
     
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
