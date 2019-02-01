//
//  RegisterViewModel.swift
//  MarketHouse
//
//  Created by Arnulfo on 1/23/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
import RxCocoa
import RxSwift

struct RegisterViewModel{
    
    var firstName = BehaviorRelay<String>(value: "")
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var confirmPassword = BehaviorRelay<String>(value: "")
    
    var fieldsEmpty : Observable<Bool>{
        return Observable.combineLatest(firstName.asObservable(), email.asObservable(), password.asObservable(), confirmPassword.asObservable(), resultSelector: { (firstName, email, password, confirmPassword) -> Bool in
            return (firstName.count == 0 || email.count == 0) || (password.count == 0 || confirmPassword.count == 0)
        })
    }
    
    var passwordDontMatch : Observable<Bool>{
        return Observable.combineLatest(password.asObservable(), confirmPassword.asObservable(),
            resultSelector: { (password, confirmPassword) -> Bool in
                return password != confirmPassword
        })
    }
    
    var notifications : Observable<String>{
        return Observable.combineLatest(fieldsEmpty.asObservable(), email.asObservable(), password.asObservable(),
            confirmPassword.asObservable(), resultSelector: { (isEmpty, email, password, confirmPassword) -> String in
            var notification = ""
            
            let emailCorrect = self.checkEmail(email: email)
            
            if isEmpty{
                notification.append(contentsOf: "*The required fields can't be empty.\n")
            }
            if !emailCorrect{
                notification.append(contentsOf: "*Email invalid.\n")
            }
            if password != confirmPassword{
                notification.append(contentsOf: "*The password don't match.\n")
            }
            if password.count < 8 || password.count > 15{
                notification.append(contentsOf: "*The password must have at least 8 and maximum 15 characters.\n")
            }
            return notification
        })
    }
    
    var isHiddenButton : Observable<Bool>{
        return Observable.combineLatest(fieldsEmpty.asObservable(), email.asObservable(), password.asObservable(), confirmPassword.asObservable(), resultSelector: {
            (isEmpty, email, password, confirmPassword) -> Bool in
            
            let emailCorrect = self.checkEmail(email: email)
            
            return isEmpty || (password != confirmPassword) || password.count < 8 || password.count > 15 || !emailCorrect
        })
    }
    
    func checkEmail(email: String) -> Bool{
        var value = true
        do{
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let result = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            if result.count == 0
            {
                value = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            value = false
        }
        return value
    }
}
