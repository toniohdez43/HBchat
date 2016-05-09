//
//  ContactsController.swift
//  HBchat
//
//  Created by Antonio  Hernandez  on 5/8/16.
//  Copyright © 2016 Antonio  Hernandez . All rights reserved.
//

import UIKit
import Quickblox

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
        
        }
        
    }


}
