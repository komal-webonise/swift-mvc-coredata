//
//  Constants.swift
//  MVCWithSwift
//
//  Created by komal lunkad on 28/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//

class Constants {
    struct Entity {
        static let ENTITY_PRODUCTS = "Products"
        static let ATTRIBUTE_PRODUCT_NAME = "productName"
        static let ATTRIBUTE_PRODUCT_PRICE = "productPrice"
        static let ATTRIBUTE_PRODUCT_CATEGORY = "productCategory"
    }
    struct StoryBoardID {
        static let ADD_PRODUCT_VIEW_CONTROLLER = "AddProductViewController"
        static let LIST_PRODUCTS_VIEW_CONTROLLER = "ListProductsViewController"
        static let TABLE_VIEW_CELL = "CustomProductViewCell"
    }
    struct showButtonText {
        static let SHOW_TEXT = "Ok"
    }
    struct RegularExpression {
        static let ALPHABETIC_EXPRESSION = "^[a-zA-Z]+$"
        static let ALPHANUMERIC_EXPRESSION = "[0-9]{2,5}[.]{0,1}[0-9]{0,2}"
    }
}
