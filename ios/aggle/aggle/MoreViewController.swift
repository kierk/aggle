//
//  MoreViewController.swift
//  aggle
//
//  This controller SHOULD be used to display all items currently listed by the user.
//  It should be renamed to ListingsViewController.
//  As of 4/22/2016, this controller does nothing.
//
//  Created by Max Li on 3/22/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
//import Firebase

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    
    let user = User.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(MoreViewController.setBttnTouched(_:)))

        
        
        
        
        
//        
//        
//        let zipRef = rootRef.childByAppendingPath("ZipDB/" + self.user.zip)
//        zipRef.queryOrderedByChild("ItemID").observeEventType(.ChildAdded, withBlock: {snapshot in
//            if let height = snapshot.value["ItemID"] as? String {
//                print("test")
//            }
//        })
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.user.numberSold
//        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        let decodedData = NSData(base64EncodedString: self.user.picArray[indexPath.row], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        cell.pic.image = UIImage(data: decodedData!)
        
        cell.price.text = self.user.priceArray[indexPath.row]
        cell.descrip.text = self.user.descArray[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    func setBttnTouched(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("moreSettingsSegue", sender: self)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
