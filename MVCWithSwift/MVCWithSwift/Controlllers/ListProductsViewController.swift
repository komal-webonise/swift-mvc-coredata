//
//  ListProducts.swift
//  MVCWithSwift
//
//  Created by komal lunkad on 27/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//

import UIKit
import CoreData

class ListProductsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableViewProducts: UITableView!
    var arrayProducts : [Products] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addProduct = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ListProductsViewController.navigateToAddProductsScreen))
        self.navigationItem.rightBarButtonItem = addProduct
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.ENTITY_PRODUCTS)
        do{
            self.arrayProducts = try (managedObjectContext.executeFetchRequest(fetchRequest)) as! [Products]
            self.tableViewProducts.reloadData()
        }
        catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /** Navigates to next screen which enables to add one more product
    */
    func navigateToAddProductsScreen() {
        let addProductViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.StoryBoardID.ADD_PRODUCT_VIEW_CONTROLLER) as! AddProductViewController
        self.navigationController?.pushViewController(addProductViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayProducts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 90;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let customCellIdentifier = Constants.StoryBoardID.TABLE_VIEW_CELL ;
        var cell = tableViewProducts.dequeueReusableCellWithIdentifier(customCellIdentifier) as? CustomProductViewCell
        if cell == nil {
            var nib = NSBundle.mainBundle().loadNibNamed(customCellIdentifier, owner: self, options: nil)
            cell = nib[0] as? CustomProductViewCell
        }
        let productDetail = self.arrayProducts[indexPath.row]
        cell?.labelProductName.text = productDetail.productName;
        cell?.labelProductPrice.text = String(productDetail.productPrice!)
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            managedObjectContext.deleteObject(self.arrayProducts[indexPath.row])
            do{
                try  managedObjectContext.save()
            }
            catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            self.arrayProducts.removeAtIndex(indexPath.row)
            self.tableViewProducts.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
           return
       }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let addProductViewController: AddProductViewController? = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.StoryBoardID.ADD_PRODUCT_VIEW_CONTROLLER) as? AddProductViewController
        addProductViewController?.showOrUpdateDetails = true
        addProductViewController?.row = indexPath.row
        self.navigationController?.pushViewController(addProductViewController!, animated: true)
    }

}