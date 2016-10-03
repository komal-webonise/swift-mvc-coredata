//
//  Products+CoreDataProperties.swift
//  MVCWithSwift
//
//  Created by komal lunkad on 28/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Products {

    @NSManaged var productCategory: String?
//        {
//        set {
//            self.setValue(newValue, forKey: "productCategory")
//        }
//        get {
//            return self.valueForKey("productCategory") as? String
//        }
//    }
    @NSManaged var productName: String?
    @NSManaged var productPrice: NSNumber?

}
