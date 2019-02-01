//
//  SelectSessionTypeViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/16/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SelectSessionTypeViewController : UIViewController {
    
    let methods = Methods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func optionOneSelected(_ sender: UIButton) {
        SVProgressHUD.show()
        save(selectedMode: "Owner")
    }
    
    @IBAction func optionTwoSelected(_ sender: UIButton) {
        SVProgressHUD.show()
        save(selectedMode: "Client")
    }
    
    func save(selectedMode: String){
        let parameter : Parameters = [
            "SessionType" : selectedMode
        ]
        let headers: HTTPHeaders = [
            "Token" : UserDefaults.standard.string(forKey: "Token")!
        ]
        
        let request = HttpRequest()
        
        request.post(vc: self, url: Constants.ApiRoot.selectSessionType, parameter: parameter, header: headers) { (json, error) in
            DispatchQueue.main.async {
                if let success = json?["Success"].bool{
                    if success{
                        UserDefaults.standard.set(selectedMode, forKey: "SessionType")
                        let view = self.methods.selectViewToDisplay()
                        self.present(view, animated: true, completion: nil)
                    }else{
                        self.methods.displayAlert(vc: self, title: "Error", message: "", actionTitle: "Accept")
                    }
                }
            }
            SVProgressHUD.dismiss()
        }
    }
}
