//
//  SettingsViewController.swift
//  aggle
//
//  Created by Max Li on 4/17/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase


class SettingsViewController: UIViewController {

    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    let user = User.sharedInstance
   
    
    
    @IBOutlet weak var zipCode: UITextField!
    
    
    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.pic.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
    
    
    
    
    override func viewDidLoad() {
        load_image(self.user.pic)
        super.viewDidLoad()
//<<<<<<< HEAD
//        //name.text = self.user.name.substringWithRange(Range<String.Index>(start: self.user.name.startIndex.advancedBy(9), end: self.user.name.endIndex.advancedBy(-1)))
//        name.text = self.user.name
//        
//        zipCode.text = self.user.zip
//        // Do any additional setup after loading the view.
//        
//        
//=======
        name.text = self.user.name
        zipCode.text = self.user.zip
//        pic.image = UIImage(named: self.user.pic)
//>>>>>>> 8fb9f77ddb85038df398454babe46b04b56e171b
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
