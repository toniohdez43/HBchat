//
//  ContactsController.swift
//  HBchat
//
//  Created by Antonio  Hernandez  on 5/8/16.
//  Copyright © 2016 Antonio  Hernandez . All rights reserved.
//

import UIKit
import Quickblox

class DialogTableViewCellModel: NSObject {
    
    var detailTextLabelText: String = ""
    var textLabelText: String = ""
    var unreadMessagesCounterLabelText : String?
    var unreadMessagesCounterHiden = true
    var dialogIcon : UIImage?
    
    init(dialog: QBChatDialog) {
        super.init()
        
        switch (dialog.type){
        case .PublicGroup:
            self.detailTextLabelText = "public group"
        case .Group:
            self.detailTextLabelText = "group"
        case .Private:
            self.detailTextLabelText = "private group"
            
            if dialog.recipientID == -1 {
                return
            }
            
            // Getting recipient from users service.
            //if let recipient = ServicesManager.instance().usersService.usersMemoryStorage.userWithID(UInt(dialog.recipientID)) {
            // self.textLabelText = recipient.login ?? recipient.email!
            //}
        }
        
        if self.textLabelText.isEmpty {
            // group chat
            
            if let dialogName = dialog.name {
                self.textLabelText = dialogName
            }
        }
        
        // Unread messages counter label
        
        if (dialog.unreadMessagesCount > 0) {
            
            var trimmedUnreadMessageCount : String
            
            if dialog.unreadMessagesCount > 99 {
                trimmedUnreadMessageCount = "99+"
            } else {
                trimmedUnreadMessageCount = String(format: "%d", dialog.unreadMessagesCount)
            }
            
            self.unreadMessagesCounterLabelText = trimmedUnreadMessageCount
            self.unreadMessagesCounterHiden = false
            
        } else {
            
            self.unreadMessagesCounterLabelText = nil
            self.unreadMessagesCounterHiden = true
        }
        
        // Dialog icon
        
        if dialog.type == .Private {
            self.dialogIcon = UIImage(named: "user")
        } else {
            self.dialogIcon = UIImage(named: "group")
        }
    }
}

class ChatsMenuController: UITableViewController{
    private var didEnterBackGroundDate: NSDate?
    
    override func viewWillAppear(animated: Bool) {
        if (QBSession.currentSession().currentUser==nil)
        {
            self.performSegueWithIdentifier("ToLogin", sender: self)
            print("No hay usuario")
            
        }
        else{
            print(QBSession.currentSession().currentUser!.login)
            let extendedRequest = ["sort_desc" : "_id"]
            
            let page = QBResponsePage(limit: 100, skip: 0)
            
            QBRequest.dialogsForPage(page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
                
            }) { (response: QBResponse) -> Void in
                
            }
            QBRequest.countOfDialogsWithExtendedRequest(nil, successBlock: { (response : QBResponse!, count : UInt) -> Void in
                
            }) { (response : QBResponse!) -> Void in
                
            }
            
        }
        
    }
    
    
}
