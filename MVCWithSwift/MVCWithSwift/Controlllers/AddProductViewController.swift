//
//  AddProduct.swift
//  MVCWithSwift
//
//  Created by komal lunkad on 27/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//
import UIKit
import CoreData

class AddProductViewController: UIViewController {
    @IBOutlet var textFieldProductName: UITextField!
    @IBOutlet var textFieldProductPrice: UITextField!
    @IBOutlet var textFieldProductCategory: UITextField!
    @IBOutlet var buttonSaveOrUpdate: UIButton!
    var show: Bool?
    var nsManagedObject: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if((self.show) != nil){
            self.buttonSaveOrUpdate.setTitle(Constants.SHOW_TEXT, forState: .Normal)
            self.displayProductDetails()
        }
    }
    
    func displayProductDetails(){
        textFieldProductName.text = self.nsManagedObject?.valueForKey(Constants.ATTRIBUTE_PRODUCT_NAME) as? String
        textFieldProductPrice.text = String((self.nsManagedObject?.valueForKey(Constants.ATTRIBUTE_PRODUCT_PRICE))!)
        textFieldProductCategory.text = self.nsManagedObject?.valueForKey(Constants.ATTRIBUTE_PRODUCT_CATEGORY) as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonAddTapped(sender: AnyObject) {
        
        let productName = textFieldProductName.text
        let productCategory = textFieldProductCategory.text
        if(!self.isWhitespace(productName!)){
            textFieldProductName.becomeFirstResponder()
        }
        else if(!self.isWhitespace(textFieldProductPrice.text!)){
            textFieldProductPrice.becomeFirstResponder()
        }
        else if(!self.isWhitespace(productCategory!)){
            textFieldProductCategory.becomeFirstResponder()
        }
        else if(!self.isAlphabetic(productName!)){
            print("Only character set allowed in product name.")
            textFieldProductName.text = ""
            textFieldProductName.becomeFirstResponder()
        }
        else if(!self.isAlphaNumeric(textFieldProductPrice.text!)){
            print("Number ranging from 10 to 99999 and after decimal point only two numbers.")
            textFieldProductPrice.text = "";
            textFieldProductPrice.becomeFirstResponder()
        }
        else if(!self.isAlphabetic(productCategory!)){
            print("Only character set allowed in product name.")
            textFieldProductCategory.text = "";
            textFieldProductCategory.becomeFirstResponder()
        }
        else{
            self.saveProduct()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func managedObjectContext() -> NSManagedObjectContext {
        var context: NSManagedObjectContext!
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if (delegate.performSelector(#selector(managedObjectContext)) != nil) {
            context = delegate.managedObjectContext
        }
        return context
    }
   
    func isWhitespace(name: String) -> Bool{
        let trimmedName:String = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmedName.characters.count == 0 {
            return false
        }
        return true
    }
    func isAlphabetic(name: String) -> Bool {
       return name.rangeOfString("^[a-zA-Z]+$", options: .RegularExpressionSearch) != nil
    }
    
    func isAlphaNumeric(name: String) -> Bool {
        return name.rangeOfString("[0-9]{2,5}[.]{0,1}[0-9]{0,2}", options: .RegularExpressionSearch) != nil
    }
    
    /** Updates or inserts new object in database
     */
    func saveProduct(){
        let context = self.managedObjectContext()
        if((self.nsManagedObject) != nil){
//            self.nsManagedObject?.setValue(self.textFieldProductName, forKey: "productName")
//            self.nsManagedObject?.setValue(Float(self.textFieldProductPrice.text! ), forKey: "productPrice")
//            self.nsManagedObject?.setValue(self.textFieldProductCategory.text, forKey: "productCategory")
        }
        else{
            if let entity = NSEntityDescription.entityForName(Constants.ENTITY_PRODUCTS, inManagedObjectContext: context) {
                let newProduct = Products(entity: entity, insertIntoManagedObjectContext: context)
                newProduct.setValue(self.textFieldProductName.text, forKey: Constants.ATTRIBUTE_PRODUCT_NAME)
                newProduct.setValue(Float(self.textFieldProductPrice.text! ), forKey: Constants.ATTRIBUTE_PRODUCT_PRICE)
                newProduct.setValue(self.textFieldProductCategory.text, forKey: Constants.ATTRIBUTE_PRODUCT_CATEGORY)
            }
        }
        do{
            try  context.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}