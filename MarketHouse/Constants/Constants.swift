//
//  Constants.swift
//  Rent House
//
//  Created by Arnulfo on 1/17/19.
//  Copyright © 2019 Arnulfo. All rights reserved.
//
struct Constants{
    
    struct StoryboardId{
        static let loginViewController = "LoginViewController"
        static let selectSessionTypeViewController = "SelectSessionTypeViewController"
        static let administratorTabViewController = "AdministratorTabViewController"
        static let ownerTabViewController = "OwnerTabViewController"
        static let clientTabViewController = "ClientTabViewController"
        static let itemsViewController = "ItemsViewController"
        static let propertiesViewController = "PropertiesViewController"
        static let vehiclesViewController = "VehiclesViewController"
    }
    
    struct ApiRoot {
        static let baseUrl = "http://softdf.tk"
        static let loginRoot = "\(baseUrl)/MarketHouseApp/public/signin"
        static let registerRoot = "\(baseUrl)/MarketHouseApp/public/register/user"
        static let selectSessionType = "\(baseUrl)/MarketHouseApp/public/update/session"
        static let getPerfil = "\(baseUrl)/MarketHouseApp/public/get/user"
        static let updatePerfil = "\(baseUrl)/MarketHouseApp/public/update/user"
        static let addProduct = "\(baseUrl)/MarketHouseApp/public/add/product"
        static let getAllPublicationsOwner = "\(baseUrl)/MarketHouseApp/public/get/allpublications/owner"
        static let getAllPublicationsClient = "\(baseUrl)/MarketHouseApp/public/get/allpublications/client"
        static let deletePublication = "\(baseUrl)/MarketHouseApp/public/delete/publication"
        static let describePublication = "\(baseUrl)/MarketHouseApp/public/describe/publication"
    }
}
