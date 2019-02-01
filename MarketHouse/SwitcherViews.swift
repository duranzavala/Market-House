//
//  Switcher.swift
//  Rent House
//
//  Created by Arnulfo on 1/17/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit

class SwictherViews{
    
    private static var rootViewController : UIViewController?
    
    static func updateRootViewController(){
        if UserDefaults.standard.string(forKey: "Token") != nil{
            selectViewToDisplay()
        }else{
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.loginViewController) as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
    }
    
    static func selectViewToDisplay(){
        
        var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        
        switch UserDefaults.standard.string(forKey: "SessionType") {
        case "Administrator":
            mainStoryBoard = UIStoryboard(name: "AdministratorTab", bundle: nil)
            rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.administratorTabViewController) as! AdministratorTabViewController
        case "Owner":
            mainStoryBoard = UIStoryboard(name: "Owner", bundle: nil)
            rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.ownerTabViewController) as! OwnerTabViewController
        case "Client":
            mainStoryBoard = UIStoryboard(name: "Client", bundle: nil)
            rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.clientTabViewController) as! ClientTabViewController
        default:
            mainStoryBoard = UIStoryboard(name: "Perfil", bundle: nil)
            rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: Constants.StoryboardId.selectSessionTypeViewController) as! SelectSessionTypeViewController
            break
        }
    }
}
