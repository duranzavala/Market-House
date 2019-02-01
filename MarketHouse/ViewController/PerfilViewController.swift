//
//  PerfilViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/24/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class PerfilViewController: UITableViewController, doneProtocol{
    
    let methods = Methods()
    let genders = ["Male", "Female"]
    var picker = UIPickerView()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()

    @IBOutlet weak var perfilImageView: UIImageView!
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var genderInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI(){
        perfilImageView.layer.cornerRadius = perfilImageView.frame.size.width/2
        perfilImageView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        perfilImageView.isUserInteractionEnabled = true
        perfilImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.refreshControl = refresher
        
        picker.delegate = self
        picker.dataSource = self
        
        genderInput.inputView = picker
        
        SVProgressHUD.show()
        getData()
    }
    
    @objc func refreshData(){
        getData()
        
        let deadLine = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadLine){
            self.refresher.endRefreshing()
        }
    }
    
    @objc func getData(){
        
        let headers: HTTPHeaders = [
            "Token" : UserDefaults.standard.string(forKey: "Token")!
        ]
        
        let request = HttpRequest()
        
        request.post(vc: self, url: Constants.ApiRoot.getPerfil, parameter: [:], header: headers) { (json, error) in
            DispatchQueue.main.async {
                if let success = json?["Success"].bool{
                    if success{
                        self.firstNameInput.text = json?["FirstName"].string
                        self.lastNameInput.text = json?["LastName"].string
                        self.phoneInput.text = json?["Phone"].string
                        self.emailInput.text = json?["Email"].string
                        self.genderInput.text = json?["Gender"].string
                        self.locationInput.text = json?["Location"].string
                        
                        if let imageUrl = json?["Photo"].string{
                            
                            if let url = URL(string: imageUrl){
                                if let data = try? Data(contentsOf: url) {
                                    if let img = UIImage(data: data) {
                                        self.perfilImageView.image = img
                                    }
                                }
                            }
                        }
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
    
    @objc func imageTapped(){
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.allowsEditing = true
        
        let alert = UIAlertController(title: "", message: "Select an option", preferredStyle: .actionSheet)
        let uploadAction = UIAlertAction(title: "Take photo", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                pickerView.sourceType = .camera
                self.present(pickerView, animated: true, completion: nil)
            }
        }
        
        let image = UIImage(named: "info")
        uploadAction.setValue(image?.withRenderingMode(.automatic), forKey: "image")
        
        alert.addAction(uploadAction)
        
        alert.addAction(UIAlertAction(title: "Upload photo", style: .default, handler: {_ in
            pickerView.sourceType = .photoLibrary
            self.present(pickerView, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    @IBAction func saveInformationButton(_ sender: UIButton) {
        let request = HttpRequest()
        SVProgressHUD.show()
        
        let parameter : Parameters = [
            "FirstName" : firstNameInput.text!,
            "LastName" : lastNameInput.text!,
            "Phone" : phoneInput.text!,
            "Gender" : genderInput.text!,
            "Location" : locationInput.text!
        ]
        
        let json = try! JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
        
        let headers : HTTPHeaders = [
            "Token" : UserDefaults.standard.string(forKey: "Token")!,
            "Content-type": "multipart/form-data"
        ]
        
        var image: [UIImage] = []
        
        if let img = perfilImageView.image{
        let imageData: Data = img.jpegData(compressionQuality: 0.1)!
            image = [UIImage(data: imageData)!]
        }
        
        request.upload(vc: self, url: Constants.ApiRoot.updatePerfil, parameter: json, pictures: image, headers: headers) { (json, error) in
            DispatchQueue.main.async { [weak self] in
                if let success = json?["Success"].bool{
                    if success{
                        self!.methods.displayAlert(vc: self!, title: "Success", message: "Perfil updated", actionTitle: "Accept")
                    }else{
                        self!.methods.displayAlert(vc: self!, title: "Error", message: "", actionTitle: "Accept")
                    }
                }
                else if let error = json?["Error"].string{
                    self!.methods.displayAlert(vc: self!, title: "Error", message: error, actionTitle: "Accept")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func done(loc: String) {
        locationInput.text = loc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationMap" {
            let vc : FindPlaceViewController = segue.destination as! FindPlaceViewController
            vc.delegate = self
        }
    }
    
    @IBAction func logOutSession(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "Token")
        UserDefaults.standard.removeObject(forKey: "SessionType")
        let view = methods.selectViewToDisplay()
        
        present(view, animated: true, completion: nil)
        
    }
    
}
