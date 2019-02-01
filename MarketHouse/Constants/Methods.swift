//
//  Methods.swift
//  Rent House
//
//  Created by Arnulfo on 1/17/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit

class Methods {
    
    func displayAlert(vc: UIViewController, title: String, message: String, actionTitle: String) -> Void{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: actionTitle, style: .default)
        alert.addAction(acceptAction)
        vc.present(alert,animated: true, completion: nil)
    }
    
    func selectViewToDisplay() -> UIViewController{
        
        var mainViewController: UIViewController
        var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if UserDefaults.standard.string(forKey: "Token") == nil{
            mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.loginViewController) as! LoginViewController
        }else{        
            switch UserDefaults.standard.string(forKey: "SessionType") {
            case "Administrator":
                mainStoryBoard = UIStoryboard(name: "Administrator", bundle: nil)
                mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.administratorTabViewController) as! AdministratorTabViewController
            case "Owner":
                mainStoryBoard = UIStoryboard(name: "Owner", bundle: nil)
                mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.ownerTabViewController) as! OwnerTabViewController
            case "Client":
                mainStoryBoard = UIStoryboard(name: "Client", bundle: nil)
                mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.clientTabViewController) as! ClientTabViewController
            default:
                mainStoryBoard = UIStoryboard(name: "Perfil", bundle: nil)
                mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.selectSessionTypeViewController) as! SelectSessionTypeViewController
            }
        }
        return mainViewController
    }
}
