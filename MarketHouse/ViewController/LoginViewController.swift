//
//  LoginViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/15/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit
import FBSDKLoginKit
import Alamofire
import SVProgressHUD
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    var viewModel = LoginViewModel()
    var disposeBag = DisposeBag()
    let methods = Methods()
    let backgroundImageView = UIImageView()
    
    @IBOutlet weak var IconImageView: UIImageView!
    @IBOutlet weak var EmailTextView: UITextField!
    @IBOutlet weak var PasswordTextView: UITextField!
    @IBOutlet weak var ForgetPasswordAttributesButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        updateUI()
    }
    
    func updateUI(){
        EmailTextView.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        PasswordTextView.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .bind(to: loginButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    @IBAction func LoginWithFacebookButton(_ sender: UIButton) {
    }
    
    @IBAction func LoginWithGoogleButton(_ sender: UIButton) {
    }
 
    @IBAction func LoginNormalButton(_ sender: UIButton) {
        SVProgressHUD.show()
        
        let parameter : Parameters = [
            "Email" : EmailTextView.text!,
            "Password" : PasswordTextView.text!
        ]
        
        let request = HttpRequest()
        
        request.post(vc: self, url: Constants.ApiRoot.loginRoot, parameter: parameter, header: [:]) { (json, error) in
            DispatchQueue.main.async {
                if let success = json?["Success"].bool{
                    if success{
                        self.navigateToSesionViewController(token: (json?["Token"].string)!, currentMode: (json?["SessionType"].string)!)
                    }else{
                        self.methods.displayAlert(vc: self, title: "Error", message: json!["Description"].string!, actionTitle: "Accept")
                    }
                }
                else if let error = json?["Error"].string{
                    self.methods.displayAlert(vc: self, title: "Error", message: error, actionTitle: "Accept")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func navigateToSesionViewController(token: String, currentMode: String){
        
        UserDefaults.standard.set(token, forKey: "Token")
        UserDefaults.standard.set(currentMode, forKey: "SessionType")
        
        let view = methods.selectViewToDisplay()
        
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func ForgetPasswordButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
