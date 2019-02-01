//
//  DetailPublicationViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/31/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MapKit
import CoreLocation

class DetailPublicationViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate{

    var idPublication : String = ""
    var images: [UIImage] = []
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let methods = Methods()
    let locationManager = CLLocationManager()
    var initialLocation : CLLocation?
    let regionInMeters: Double = 1000
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titlePublication: UILabel!
    @IBOutlet weak var pricePublication: UILabel!
    @IBOutlet weak var conditionPublication: UILabel!
    @IBOutlet weak var stockPublication: UILabel!
    @IBOutlet weak var descriptionPublication: UILabel!
    @IBOutlet weak var nameSeller: UILabel!
    @IBOutlet weak var phoneSeller: UILabel!
    @IBOutlet weak var photoSeller: PerfilImage!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationSeller: UILabel!
    @IBOutlet weak var callUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
        
        mapView.delegate = self
        centerViewOnUserLocation()
        initialLocation = getCenterLocation(for: mapView)
        
        requestData()
    }


    func getCenterLocation(for: MKMapView) -> CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
	
    func initUI(){
        self.title = "Details"
        
        pageControl.numberOfPages = images.count
        for index in 0..<images.count{
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = images[index]
            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func requestData(){
        
        let parameter = [
            "IdPublication" : idPublication
        ]
        
        let headers: HTTPHeaders = [
            "Token" : UserDefaults.standard.string(forKey: "Token")!
        ]
        
        let request = HttpRequest()
        
        request.post(vc: self, url: Constants.ApiRoot.describePublication, parameter: parameter, header: headers) { (json, error) in
            DispatchQueue.main.async { [weak self] in
                if let success = json?["Success"].bool{
                    if success{
                        if let pictures = json?["Pictures"].object{
                            for item in pictures as! [Dictionary<String,Any>]{
                                
                                let imageUrl = item["Location"] as! String
                                
                                if let url = URL(string: imageUrl){
                                    if let data = try? Data(contentsOf: url) {
                                        if let img = UIImage(data: data) {
                                            self!.images.append(img)
                                        }
                                    }
                                }
                            }
                            self!.initUI()
                        }
                        if let description = json?["Description"].dictionary{
                            self!.titlePublication.text = description["Title"]!.string
                            self!.descriptionPublication.text = description["Description"]?.string
                            self!.conditionPublication.text = description["Condition"]!.string
                            self!.stockPublication.text =  "Stock: " + description["Stock"]!.string!
                            self!.pricePublication.text = "$" + description["Price"]!.string!
                            self!.locationSeller.text = description["Location"]?.string
                            if let location = self!.locationSeller.text{
                                self!.getLocation(location: location)
                            }
                        }
                        if let about = json?["About"].dictionary{
                            self!.nameSeller.text = "\(String(describing: about["FirstName"]!)) \(String(describing: about["LastName"]!))"
                            self!.phoneSeller.text = about["Phone"]?.string
                            if (self!.phoneSeller.text?.isEmpty)!{
                                self!.callUser.isHidden = true
                            }
                            if let photo = json?["Photo"].string{
                                if let url = URL(string: photo){
                                    if let data = try? Data(contentsOf: url) {
                                        if let img = UIImage(data: data) {
                                            self!.photoSeller.image = img
                                        }
                                    }
                                }
                            }else{
                                self!.photoSeller.image = UIImage(named: "background")
                            }
                        }
                    }else{
                        self!.methods.displayAlert(vc: self!, title: "Error", message: json!["Description"].string!, actionTitle: "Accept")
                    }
                }
                else if let error = json?["Error"].string{
                    self!.methods.displayAlert(vc: self!, title: "Error", message: error, actionTitle: "Accept")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func getLocation(location: String){

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location

        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: initialLocation!.coordinate, span: span)

        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })
        
        mapView.setCenter(initialLocation!.coordinate, animated: true)
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func callSellerButton(_ sender: UIButton) {
        guard let number = phoneSeller.text else{ return }
        
        guard let url = URL(string: "telprompt://\(number)") else { return }
        
        UIApplication.shared.open(url)
    }
}
