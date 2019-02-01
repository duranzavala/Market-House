//
//  LoginViewModel.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/23/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import RxSwift
import RxCocoa

struct LoginViewModel {
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    var isValid : Observable<Bool>{
        return Observable.combineLatest(username.asObservable(), password.asObservable(), resultSelector: { (username, password) -> Bool in
            return username.count == 0 || password.count == 0
        })
    }
}
