//
//  RegisterViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/16/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import RxAlamofire

class RegisterViewController: UIViewController{
    
    var viewModel = RegisterViewModel()
    var disposeBag = DisposeBag()
    let methods = Methods()
    let backgroundImageView = UIImageView()
    
    @IBOutlet weak var firstNameTextView: UITextField!
    @IBOutlet weak var lastNameTextView: UITextField!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var confirmPasswordTextView: UITextField!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var goToLoginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        updateUI()
    }
    
    func updateUI(){
        firstNameTextView.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        emailTextView.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextView.rx.text.map({$0 ?? ""})
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        confirmPasswordTextView.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.confirmPassword)
            .disposed(by: disposeBag)
        
        viewModel.notifications
            .bind(to: notificationsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isHiddenButton
            .bind(to: registerButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        SVProgressHUD.show()
        
        let parameter : Parameters = [
            "FirstName" : firstNameTextView.text!,
            "LastName" : lastNameTextView.text!,
            "Email" : emailTextView.text!,
            "Password" : passwordTextView.text!
        ]
        
        let request = HttpRequest()
        
        request.post(vc: self, url: Constants.ApiRoot.registerRoot, parameter: parameter, header: [:]) { (json, error) in
            if let success = json?["Success"].bool{
                if success{
                    self.methods.displayAlert(vc: self, title: "Success", message: "exito", actionTitle: "Accept")
                    self.cleanFields()
                }else{
                    self.methods.displayAlert(vc: self, title: "Error", message: json!["Description"].string!, actionTitle: "Accept")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func cleanFields(){
        firstNameTextView.text = ""
        lastNameTextView.text = ""
        emailTextView.text = ""
        passwordTextView.text = ""
        confirmPasswordTextView.text = ""
    }
    
    @IBAction func goToLoginButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
