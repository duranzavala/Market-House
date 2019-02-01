//
//  ViewSelector.swift
//  Rent House
//
//  Created by Arnulfo on 1/17/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit

class ViewSelector{
    
    func selectViewToDisplay() -> UIViewController{
        
        var mainViewController: UIViewController
        
        switch UserDefaults.standard.string(forKey: "CurrentMode") {
        case "Apartment_One":
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ApartmentOptionOneViewController") as! SelectModeViewController
        case "Apartment_Two":
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ApartmentOptionTwoViewController") as! SelectModeViewController
        case "People_One":
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "PeopleOptionOneViewController") as! SelectModeViewController
        case "People_Two":
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "PeopleOptionTwoViewController") as! SelectModeViewController
        default:
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SelectModeViewController") as! SelectModeViewController
        }
        
        return mainViewController
    }
}
