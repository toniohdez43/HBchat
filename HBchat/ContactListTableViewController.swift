//
//  ContactListTableViewController.swift
//  HBchat
//
//  Created by Antonio  Hernandez  on 4/24/16.
//  Copyright © 2016 Antonio  Hernandez . All rights reserved.
//

import UIKit
import XMPPFramework
import xmpp_messenger_ios
protocol ContactPickerDelegate {
    func didSelectContact(recipient: XMPPUserCoreDataStorageObject)
}

class ContactListTableViewController: UITableViewController, OneRosterDelegate{
    var delegate:ContactPickerDelegate?
    @IBAction func close(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewWillAppear(animated: Bool) {
        OneChat.sharedInstance.connect(username: kXMPP.myJID, password: kXMPP.myPassword) { (stream, error) -> Void in
            if let _ = error {
                self.performSegueWithIdentifier("One.HomeToSettings", sender: self)
            } else {
                //set up online UI
                
                
            }
        }
        OneRoster.sharedInstance.delegate = self
    }
    override func viewWillDisappear(animated: Bool) {
        
        OneRoster.sharedInstance.delegate = nil
    }
    func oneRosterContentChanged(controller: NSFetchedResultsController) {
        //Will reload the tableView to reflect roster's changes
        tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections: NSArray? =  OneRoster.buddyList.sections
        
        if section < sections!.count {
            let sectionInfo: AnyObject = sections![section]
            
            return sectionInfo.numberOfObjects
        }
        
        return 0;
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectContact(OneRoster.userFromRosterAtIndexPath(indexPath: indexPath))
        close(self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return OneRoster.buddyList.sections!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections: NSArray? = OneRoster.sharedInstance.fetchedResultsController()!.sections
        
        if section < sections!.count {
            let sectionInfo: AnyObject = sections![section]
            let tmpSection: Int = Int(sectionInfo.name)!
            
            switch (tmpSection) {
            case 0 :
                return "Available"
                
            case 1 :
                return "Away"
                
            default :
                return "Offline"
                
            }
        }
        
        return ""
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("OneCellReuse", forIndexPath: indexPath)
        let user = OneRoster.userFromRosterAtIndexPath(indexPath: indexPath)
        
        cell!.textLabel!.text = user.displayName;
        
        if user.unreadMessages.intValue > 0 {
            cell!.backgroundColor = .orangeColor()
        } else {
            cell!.backgroundColor = .whiteColor()
        }
        OneChat.sharedInstance.configurePhotoForCell(cell!, user: user)
        
        return cell!;
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
