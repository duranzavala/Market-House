//
//  ItemsViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/28/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import UIKit
import RxCocoa
import RxSwift
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ItemsViewController: UIViewController, doneProtocol{
   
    let viewModel = ItemsViewModel()
    let disposeBag = DisposeBag()
    let methods = Methods()
    let request = HttpRequest()
    var imagesCollection : [UIImage] = []
    var conditionPicker : [String] = ["Nuevo", "Usado"]
    var imagePicker = UIImagePickerController()
    var picker = UIPickerView()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionImagesView: UICollectionView!
    @IBOutlet weak var countImages: UILabel!
    @IBOutlet weak var titleProduct: InputText!
    @IBOutlet weak var descriptionProduct: UITextView!
    @IBOutlet weak var condition: InputText!
    @IBOutlet weak var stock: InputText!
    @IBOutlet weak var price: InputText!
    @IBOutlet weak var location: InputText!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        updateUI()
    }
    
    func initUI(){
        imagePicker.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        condition.inputView = picker
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveProduct))
    }
    
    func updateUI(){
        titleProduct.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)

        condition.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.condition)
            .disposed(by: disposeBag)
      
        stock.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.stock)
            .disposed(by: disposeBag)
        
        price.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.price)
            .disposed(by: disposeBag)
        
        location.rx.text.map({ $0 ?? ""})
            .bind(to: viewModel.location)
            .disposed(by: disposeBag)
        
        viewModel.IsEmpty
            .bind(to: navigationItem.rightBarButtonItem!.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func done(loc: String) {
        location.text = loc
        location.sendActions(for: .allEditingEvents)
    }
    
    @objc func saveProduct(){
        if imagesCollection.count < 2{
            methods.displayAlert(vc: self, title: "Error", message: "You need add at least 2 images", actionTitle: "Accept")
        }else{
            save()
        }
    }
    
    func save(){
        SVProgressHUD.show()
                
        let parameter : Parameters = [
            "Title" : titleProduct.text!,
            "Description" : descriptionProduct.text!,
            "Condition" : condition.text!,
            "Stock" : stock.text!,
            "Price" : price.text!,
            "Location" : location.text!
        ]
        
        let json = try! JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)        
        
        let headers : HTTPHeaders = [
            "Token" : UserDefaults.standard.string(forKey: "Token")!,
            "Content-type": "multipart/form-data"
        ]
        
        request.upload(vc: self, url: Constants.ApiRoot.addProduct, parameter: json, pictures: imagesCollection, headers: headers) { (json, error) in
            DispatchQueue.main.async { [weak self] in
                if let success = json?["Success"].bool{
                    if success{
                        let view = self!.methods.selectViewToDisplay()
                        self!.present(view, animated: true, completion: nil)
                    }
                }
                else if let error = json?["Error"].string{
                    self!.methods.displayAlert(vc: self!, title: "Error", message: error, actionTitle: "Accept")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func addImages(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        //imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationMap" {
            let vc : FindPlaceViewController = segue.destination as! FindPlaceViewController
            vc.delegate = self
        }
    }
}
