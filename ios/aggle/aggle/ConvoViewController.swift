//
//  ConvoViewController.swift
//  aggle
//
//  This view controller displays a list of conversations. It should be renamed ConvosViewController.swift
//
//  Created by Max Li on 3/22/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import Firebase

class ConvoViewController: UITableViewController {
    
    var convos = [Convo]()
    var TAG: String! = "[ConvoViewController]"
    let rootRef = Firebase(url:"https://aggle2.firebaseio.com/")
    var userConvosRef: Firebase!

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Add the top bar w/ settings button */
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(ConvoViewController.setBttnTouched(_:)))
        
        // Do any additional setup after loading the view.
        self.userConvosRef = rootRef.childByAppendingPath("UsersDB/" + rootRef.authData.uid! + "/Conversations")

        observeUserConvos()
        
        /* This is to test... too lazy to create a test class right now */
        //testConvos()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convos.count;
    }
    
    /**
    * Update each ConvoTableViewCell with data pulled from the list of Convos */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "ConvoTableViewCell";
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ConvoTableViewCell
        
        let convo = convos[indexPath.row]
        
        cell.itemTitle.text = convo.item().title()
        cell.itemText.text = convo.item().desc()
        let decodedData = NSData(base64EncodedString: convo.item().pic()!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        cell.itemImageView.image = UIImage(data: decodedData!)// TODO(eugenek): Need to actually have valid b64 data here, and it won't atm w/ the test
        
        return cell
    }
    
    func setBttnTouched(sender: UIBarButtonItem) {
        performSegueWithIdentifier("convoSettingsSegue", sender: self)
    }
    
    private func observeUserConvos() {
        print(TAG + "observeUserConvos")
        //let messagesQuery = self.messageRef.queryLimitedToLast(25)
        
        userConvosRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            print(self.TAG + "we just observed a new convo!")
            print(self.TAG + snapshot.description)
            
            let convoId = snapshot.value as! String
            let convoRef = self.rootRef.childByAppendingPath("ConvoDB/" + convoId + "/item")
            
            convoRef.observeEventType(.Value, withBlock: { snapshot in
                let description = snapshot.value["Description"] as! String
                let itemzip = snapshot.value["ItemZipCode"] as! String
                let owner = snapshot.value["OwnerID"] as! String
                let pic = snapshot.value["base64Encoding"] as! String
                let price = snapshot.value["Price"] as! String
                
                let item = Item(title: "Testy McTestface",
                    description: description,
                    itemzip: itemzip,
                    owner: owner,
                    pic: pic,
                    price: price,
                    soldto: "")
                
                let convo = Convo(id: convoId,
                    messages: [],
                    item: item)

                self.convos.append(convo)
                self.tableView.reloadData()

            })
        })
    }
    
    /**
    * Used to just test/mock load convos */
    func testConvos() {
        // Create some testing items
        let item1 = Item(title: "Tardis",
                         description: "Great time travel machine",
                         itemzip: "90210",
                         owner: "The Doctor",
                         pic: "somepicdata",
                         price: "1234",
                         soldto: "")
        let item2 = Item(title: "DeLorean time machine",
                         description: "A more stylish time travel machine",
                         itemzip: "90210",
                         owner: "Doc",
                         pic: "somepicdata2",
                         price: "1234",
                         soldto: "")
        
        // Start some conversations about them
        let convo1 = Convo(id: "-KFt11myiuNbselRNDI5", messages: [], item: item1)
        let msg1 = Message(text: "Hello there", senderId: "1231123", senderDisplayName: "Scott")
        let msg2 = Message(text: "What do you want?", senderId: "123116", senderDisplayName: "The Doctor")
        convo1.addMessage(msg1)
        convo1.addMessage(msg2)
        
        let msg3 = Message(text: "This is another message", senderId: "1661", senderDisplayName: "Timmy")
        let convo2 = Convo(id: "-KGAPApTawqNczUreSxd", messages: [msg3], item: item2)
        
        self.convos = [convo1, convo2]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(TAG + segue.identifier!)
        if segue.identifier == "ConvoTableViewCellSegue", let destination = segue.destinationViewController as? MessageViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                let convo = convos[indexPath.row]
                destination.convo = convo
            }
        }
    }
    
}
