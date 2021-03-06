//
//  ViewController.swift
//  HBchat
//
//  Created by Antonio  Hernandez  on 4/24/16.
//  Copyright © 2016 Antonio  Hernandez . All rights reserved.
//

import UIKit
import XMPPFramework
import xmpp_messenger_ios


class OpenChatsTableViewController: UITableViewController, OneRosterDelegate {
    var chatList = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        // Do any additional setup after loading the view, typically from a nib.
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
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "chat.to.add" {
            if !OneChat.sharedInstance.isConnected() {
                let alert = UIAlertController(title: "Attention", message: "You have to be connected to start a chat", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue?.identifier == "chats.to.chat" {
            if let controller = segue?.destinationViewController as? ChatViewController {
                if let cell: UITableViewCell? = sender as? UITableViewCell {
                    let user = OneChats.getChatsList().objectAtIndex(tableView.indexPathForCell(cell!)!.row) as! XMPPUserCoreDataStorageObject
                    controller.recipient = user
                }
            }
        }
    }
    override func viewWillDisappear(animated: Bool) {
        
        OneRoster.sharedInstance.delegate = nil
    }
    func oneRosterContentChanged(controller: NSFetchedResultsController) {
        //Will reload the tableView to reflect roster's changes
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OneChats.getChatsList().count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("OneCellReuse", forIndexPath: indexPath)
        let user = OneChats.getChatsList().objectAtIndex(indexPath.row) as! XMPPUserCoreDataStorageObject
        
        cell!.textLabel!.text = user.displayName
        
        OneChat.sharedInstance.configurePhotoForCell(cell!, user: user)
        
        cell?.imageView?.layer.cornerRadius = 24
        cell?.imageView?.clipsToBounds = true
        
        return cell!
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }


}

