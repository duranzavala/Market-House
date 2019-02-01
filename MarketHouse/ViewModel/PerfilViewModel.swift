//
//  PerfilViewModel.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/25/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import RxCocoa
import RxSwift

struct PerfilViewModel{
    
    var firstName = BehaviorRelay<String>(value: "")
    var lastName = BehaviorRelay<String>(value: "")
    var phone = BehaviorRelay<String>(value: "")
    var email = BehaviorRelay<String>(value: "")
    var gender = BehaviorRelay<String>(value: "")
    var location = BehaviorRelay<String>(value: "")
    
    var isHiddenButton : Observable<Bool>{
        return Observable.combineLatest(firstName.asObservable(), lastName.asObservable(), phone.asObservable(), email.asObservable(), gender.asObservable(), location.asObservable(), resultSelector: { (firstName, lastName, phone, email, gender, location) -> Bool in
            return false
        })
    }
}
