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
    override func viewDidLoad() {
        super.viewDidLoad()
        let addProduct = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ListProductsViewController.addProducts))
        self.navigationItem.rightBarButtonItem = addProduct
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let managedObjectContext = self.managedObjectContext()
        let fetchRequest = NSFetchRequest(entityName : Constants.ENTITY_PRODUCTS)
        do{
            self.arrayProducts = try (managedObjectContext.executeFetchRequest(fetchRequest)) as! [Products]
            self.tableViewProducts.reloadData()
        }
        catch {
            fatalError("Failed to fetch data: \(error)")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addProducts() {
        let addProductViewController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.ADD_PRODUCT_VIEW_CONTROLLER) as! AddProductViewController
        self.navigationController?.pushViewController(addProductViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayProducts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 90;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let customCellIdentifier = Constants.TABLE_VIEW_CELL ;
        var cell = tableViewProducts.dequeueReusableCellWithIdentifier(customCellIdentifier) as? TableViewCell
        if cell == nil {
            var nib = NSBundle.mainBundle().loadNibNamed(customCellIdentifier, owner: self, options: nil)
            cell = nib[0] as? TableViewCell
        }
        let productDetail = self.arrayProducts[indexPath.row]
        cell?.labelProductName.text = productDetail.productName;
        cell?.labelProductPrice.text = String(productDetail.productPrice!)
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        let context = self.managedObjectContext()
        switch editingStyle {
        case .Delete:
            context.deleteObject(self.arrayProducts[indexPath.row])
            do{
                try  context.save()
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
        let productDetail = self.arrayProducts[indexPath.row]
        let addProductViewController: AddProductViewController? = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.ADD_PRODUCT_VIEW_CONTROLLER) as? AddProductViewController
        addProductViewController?.show = true
        addProductViewController?.nsManagedObject = productDetail
        self.navigationController?.pushViewController(addProductViewController!, animated: true)
    }

}