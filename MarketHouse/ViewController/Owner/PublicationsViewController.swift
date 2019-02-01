//
//  PublicationsViewController.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/28/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
import Alamofire
import SVProgressHUD

struct PublicationsStructure{
    let image: UIImage
    let idPublication: String
    let title: String
    let description: String
}

class PublicationsViewController: UIViewController, UITableViewDelegate {

    var publicationsArray = BehaviorRelay<[PublicationsStructure]>(value: [])
    
    
    let disposeBag = DisposeBag()
    let methods = Methods()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var publications: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        requestData()
        
        publications.delegate = self
        
        updateUI()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let cell = self.publications.cellForRow(at: indexPath) as! PublicationsViewCell
            self.removeRequest(idPublication: cell.idPublicationCell!, index: indexPath)
            completion(true)
        }
        action.image = UIImage(named: "remove")
        action.backgroundColor = UIColor.red
        return action
    }
    
    func removeRequest(idPublication: String, index: IndexPath){
        
        let parameters = [
            "IdPublication" : idPublication
        ]
        
        let headers: HTTPHeaders = [
            "Token" : UserDefaults.standard.string(forKey: "Token")!
        ]
        
        let request = HttpRequest()
        
        request.post(vc: self, url: Constants.ApiRoot.deletePublication, parameter: parameters, header: headers) { (json, error) in
            DispatchQueue.main.async { [weak self] in
                    if let success = json?["Success"].bool{
                        if success{
                            self!.refreshData()
                        }else{
                            self!.methods.displayAlert(vc: self!, title: "Error", message: "Error", actionTitle: "Accept")
                        }
                    }
                    else if let error = json?["Error"].string{
                        self!.methods.displayAlert(vc: self!, title: "Error", message: error, actionTitle: "Accept")
                    }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func updateUI(){
        
        self.publications.refreshControl = refresher
        
        publicationsArray
            .asObservable()
            .bind(to: publications.rx.items(cellIdentifier: "PublicationsViewCell")){
                _ , publicationStructure, cell in
                if let cellToUse = cell as? PublicationsViewCell{
                    cellToUse.imageCell.image = publicationStructure.image
                    cellToUse.titleCell.text = publicationStructure.title
                    cellToUse.descriptionCell.text = publicationStructure.description
                    cellToUse.idPublicationCell = publicationStructure.idPublication
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc func refreshData(){
        
        publicationsArray.accept([])
        requestData()
        
        let deadLine = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadLine){
            self.refresher.endRefreshing()
        }
    }
    
    func setPublications(image: UIImage, id: String ,title: String, description: String){
        publicationsArray.accept(publicationsArray.value + [PublicationsStructure(image: image, idPublication: id , title: title, description: description)])
    }
    
    func requestData(){
        let headers: HTTPHeaders = [
            "Token" : UserDefaults.standard.string(forKey: "Token")!
        ]
        
        let request = HttpRequest()
        
        request.post(vc: self, url: Constants.ApiRoot.getAllPublicationsOwner, parameter: [:], header: headers) { (json, error) in
            DispatchQueue.main.async { [weak self] in
                if let success = json?["Success"].bool{
                    if success{
                        if let publications = json?["Publications"].object{
                            for item in publications as! [Dictionary<String,Any>]{
                                
                                let title = item["Title"] as! String
                                let description = item["Description"] as! String
                                let id = item["IdPublication"] as! String
                                
                                let imageUrl = item["Location"] as! String
                                
                                if let url = URL(string: imageUrl){
                                    if let data = try? Data(contentsOf: url) {
                                        if let img = UIImage(data: data) {
                                            self!.setPublications(image: img, id: id, title: title, description: description)
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        self?.methods.displayAlert(vc: self!, title: "Error", message: json!["Description"].string!, actionTitle: "Accept")
                    }
                }
                else if let error = json?["Error"].string{
                    self?.methods.displayAlert(vc: self!, title: "Error", message: error, actionTitle: "Accept")
                }
            }
            SVProgressHUD.dismiss()
        }
    }
}
