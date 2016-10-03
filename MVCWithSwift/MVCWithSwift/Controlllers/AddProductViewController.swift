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
    var showOrUpdateDetails: Bool = false
    var row: Int = 0
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.showOrUpdateDetails) {
            self.buttonSaveOrUpdate.setTitle(Constants.showButtonText.SHOW_TEXT, forState: .Normal)
            self.displayProductDetails()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /** Fetches data from database and sets the textfields of screen with required product object details
    */
    func displayProductDetails(){
        let fetchRequest = NSFetchRequest(entityName: Constants.Entity.ENTITY_PRODUCTS)
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            let products = results as! [Products]
            if (products.count == 0) {
                print("No records found")
            }
            textFieldProductName.text = products[row].productName
            textFieldProductPrice.text = String((products[row].productPrice)!)
            textFieldProductCategory.text = products[row].productCategory
        }
        catch let error as NSError  {
            print("Could not display \(error), \(error.userInfo)")
        }
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
   
    //MARK:IsWhitespace
    /** Checks whether the input is empty or not
     * param name: input string to be checked
     * returns false if empty string else returns true
     */
    func isWhitespace(name: String) -> Bool{
        let trimmedName:String = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmedName.characters.count == 0 {
            return false
        }
        return true
    }
    
    //MARK:IsAlphabetic
    /** Checks whether the input is alphabetic only
     * param name: input string to be checked
     * returns true if string has alphabets else returns false
     */
    func isAlphabetic(name: String) -> Bool {
       return name.rangeOfString(Constants.RegularExpression.ALPHABETIC_EXPRESSION, options: .RegularExpressionSearch) != nil
    }
    
    //MARK:IsAlphaNumeric
    /** Checks whether the input is numeric
     * param name: input string to be checked
     * returns true if string is numeric else returns false
     */
    func isAlphaNumeric(name: String) -> Bool {
        return name.rangeOfString(Constants.RegularExpression.ALPHANUMERIC_EXPRESSION, options: .RegularExpressionSearch) != nil
    }
    
    /** Updates or inserts new object in database
     */
    func saveProduct() {
        if (self.showOrUpdateDetails ) {
            updateDb()
        }
        else{
            insertObjectInDb()
        }
        do{
            try  managedObjectContext.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /** Updates an object in database
     */
    func updateDb() {
        let fetchRequestWithPredicate = NSFetchRequest(entityName: Constants.Entity.ENTITY_PRODUCTS)
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequestWithPredicate)
            let product = result as! [Products]
            let updatedproduct = product[row]
            updatedproduct.productName = self.textFieldProductName.text
            updatedproduct.productPrice = Float(self.textFieldProductPrice.text!)
            updatedproduct.productCategory = self.textFieldProductCategory.text
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    /** Inserts new object in database
     */
    func insertObjectInDb() {
        if let entity = NSEntityDescription.entityForName(Constants.Entity.ENTITY_PRODUCTS, inManagedObjectContext: managedObjectContext) {
            let newProduct = Products(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
            newProduct.productName = self.textFieldProductName.text
            newProduct.productPrice = Float(self.textFieldProductPrice.text!)
            newProduct.productCategory = self.textFieldProductCategory.text
        }
    }
}