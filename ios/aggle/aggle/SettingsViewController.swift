//
//  SettingsViewController.swift
//  aggle
//
//  Created by Max Li on 4/17/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var name: UILabel!
    let user = User.sharedInstance
    
    @IBOutlet weak var zipCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = self.user.name.substringWithRange(Range<String.Index>(start: self.user.name.startIndex.advancedBy(9), end: self.user.name.endIndex.advancedBy(-1)))
        
        zipCode.text = self.user.zip
        // Do any additional setup after loading the view.
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
