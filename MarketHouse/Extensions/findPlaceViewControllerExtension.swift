//
//  findPlaceViewControllerExtension.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/29/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import MapKit
import CoreLocation

extension FindPlaceViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension FindPlaceViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previusLocation = self.previousLocation else { return }
        
        guard center.distance(from: previusLocation) > 10 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error{
                return
            }
            
            guard let placemark = placemarks?.first else{
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.searchPlace.text = "\(streetNumber) \(streetName)"
                self.searchPlace.sendActions(for: .valueChanged)
            }
        }
    }
}
