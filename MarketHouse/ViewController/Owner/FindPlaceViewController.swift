//
//  FindPlaceViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/29/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

protocol doneProtocol {
    func done(loc: String)
}

class FindPlaceViewController: UIViewController {
  
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    let disposeBag = DisposeBag()
    var previousLocation: CLLocation?
    var delegate: doneProtocol?
    
    @IBOutlet weak var searchPlace: InputText!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Map"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(done))
        
        checkLocationServices()
        updateUI()
    }
    
    func updateUI(){
        
        searchPlace.rx.controlEvent([.valueChanged])
            .asObservable()
            .subscribe({ [unowned self] _ in
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }).disposed(by: disposeBag)
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
            break
        case .denied:
            // Show alert instructing them hoy to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func startTrackingUserLocation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for: MKMapView) -> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func search(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchPlace.text
        searchRequest.region = mapView.region
        
        view.endEditing(true)
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            guard let response = response else {
                return
            }
            
            let latitude = response.boundingRegion.center.latitude
            let longitude = response.boundingRegion.center.longitude
            
            self.mapView.showsUserLocation = true
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)

            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: self.regionInMeters, longitudinalMeters: self.regionInMeters)
            
            self.mapView.setRegion(region, animated: true)
            
            self.previousLocation = CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    @objc func done(){
        delegate?.done(loc: searchPlace.text!)
        navigationController?.popViewController(animated: true)
    }
}
