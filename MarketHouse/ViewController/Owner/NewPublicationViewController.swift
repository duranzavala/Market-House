//
//  NewPublicationViewController.swift
//  Rent House
//
//  Created by Arnulfo on 1/18/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit

class NewPublicationViewController: UIViewController {
    
    let methods = Methods()
    let mainStoryBoard = UIStoryboard(name: "OwnerPublications", bundle: nil)
    
    @IBOutlet weak var itemsImage: UIImageView!
    @IBOutlet weak var propertiesImage: UIImageView!
    @IBOutlet weak var vehiclesImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    func initUI(){
        itemsImage.layer.cornerRadius = itemsImage.frame.size.width/2
        itemsImage.clipsToBounds = true
        
        let tapGestureRecognizerItems = UITapGestureRecognizer(target: self, action: #selector(items))
        itemsImage.isUserInteractionEnabled = true
        itemsImage.addGestureRecognizer(tapGestureRecognizerItems)
        
        propertiesImage.layer.cornerRadius = propertiesImage.frame.size.width/2
        propertiesImage.clipsToBounds = true
        
        let tapGestureRecognizerProperties = UITapGestureRecognizer(target: self, action: #selector(properties))
        propertiesImage.isUserInteractionEnabled = true
        propertiesImage.addGestureRecognizer(tapGestureRecognizerProperties)
        
        vehiclesImage.layer.cornerRadius = vehiclesImage.frame.size.width/2
        vehiclesImage.clipsToBounds = true
        
        let tapGestureRecognizerVehicles = UITapGestureRecognizer(target: self, action: #selector(vehicles))
        vehiclesImage.isUserInteractionEnabled = true
        vehiclesImage.addGestureRecognizer(tapGestureRecognizerVehicles)
    }
    
    @objc func items(){
        let vc : UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.itemsViewController) as! ItemsViewController
        vc.title = "Products"
        navigationController?.pushViewController(vc,animated: true)
    }
    
    @objc func properties(){
        let vc : UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.propertiesViewController) as! PropertiesViewController
        vc.title = "Properties"
        navigationController?.pushViewController(vc,animated: true)
    }
    
    @objc func vehicles(){
        let vc : UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.vehiclesViewController) as! VehiclesViewController
        vc.title = "Vehicles"
        navigationController?.pushViewController(vc,animated: true)
    }

}
