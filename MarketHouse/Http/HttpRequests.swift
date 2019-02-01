//
//  HttpRequests.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/23/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

class HttpRequest{
    
    var disposeBag = DisposeBag()
    
    func post(vc: UIViewController, url: String, parameter: Parameters, header: HTTPHeaders, completionHandler: @escaping (JSON?, Error?) -> ()){
       
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) -> Void in
            if response.result.isSuccess{
                let json = JSON(response.result.value!)
                completionHandler(json,nil)
            }else if response.result.isFailure{
                Methods().displayAlert(vc: vc, title: "Error", message: "An error occurred connecting to the database", actionTitle: "Accept")
                completionHandler(nil,nil)
            }
        }
    }
    
    func upload(vc: UIViewController, url: String, parameter: Data, pictures: [UIImage] ,headers: HTTPHeaders, completionHandler: @escaping (JSON?, Error?) -> ()){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(parameter, withName: "Json")
            for index in 0..<pictures.count {
                let imageData = pictures[index].jpegData(compressionQuality: 0.5)!
                multipartFormData.append(imageData, withName: "Image\(index)", fileName: "Image\(index).jpeg", mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let err = response.error{
                        completionHandler(nil,err)
                        return
                    }
                    let json = JSON(response.result.value!)
                    completionHandler(json,nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completionHandler(nil,error)
            }
        }
        
    }
}
