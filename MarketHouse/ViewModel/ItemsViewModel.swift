//
//  ItemsViewModel.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/29/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//

import RxSwift
import RxCocoa

struct ItemsViewModel {
    
    var title = BehaviorRelay<String>(value: "")
    var condition = BehaviorRelay<String>(value: "")
    var stock = BehaviorRelay<String>(value: "")
    var price = BehaviorRelay<String>(value: "")
    var location = BehaviorRelay<String>(value: "")
    
    var IsEmpty : Observable<Bool>{
        return Observable.combineLatest(title.asObservable(), condition.asObservable(), stock.asObservable(), price.asObservable(), location.asObservable(), resultSelector: { (title, condition, stock, price, location) -> Bool in
            return !title.isEmpty && !condition.isEmpty && !stock.isEmpty && !price.isEmpty && !location.isEmpty
        })
    }
}
