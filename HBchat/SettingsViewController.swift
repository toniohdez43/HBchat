//
//  SettingsViewController.swift
//  HBchat
//
//  Created by Antonio  Hernandez  on 4/24/16.
//  Copyright © 2016 Antonio  Hernandez . All rights reserved.
//

import UIKit
import XMPPFramework
import xmpp_messenger_ios
import Quickblox

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var domainTextF: UITextField!
    @IBOutlet var usernameTextF: UITextField!
    @IBOutlet var passwordTextF: UITextField!
    @IBOutlet var validateBttn:  UIButton!
    
    @IBAction func validate(sender: AnyObject) {
        if OneChat.sharedInstance.isConnected() {
            OneChat.sharedInstance.disconnect()
            QBRequest.logOutWithSuccessBlock({ (response:QBResponse) in
                print("logged out")
                }, errorBlock:   { (response:QBResponse) in                  print("unable to logout")})
            usernameTextF.hidden = false
            passwordTextF.hidden = false
            validateBttn.setTitle("Validate", forState: UIControlState.Normal)
        } else {
            if self.domainTextF.text! != ""
            {
            OneChat.sharedInstance.xmppStream?.hostName=self.domainTextF.text!
            }
            
            OneChat.sharedInstance.connect(username: self.usernameTextF.text!, password:    self.passwordTextF.text!) { (stream, error) -> Void in
                if let _ = error {
                    let alertController = UIAlertController(title: "Sorry", message: "An error occured: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                        //do something
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let user:QBUUser! = QBUUser()
                    user.password=self.passwordTextF.text!
                    user.login = self.usernameTextF.text!
                    QBRequest.signUp(user, successBlock: { (response:QBResponse,user: QBUUser?) in
                        print("logro el sign")
                        self.login(self.usernameTextF.text!, password: self.passwordTextF.text!)
                        }, errorBlock: { (response:QBResponse) in
                        self.login(user?.login, password: user?.password)
                    })
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func successBlock() -> (response: QBResponse, user: QBUUser?) -> Void {
        return {(response: QBResponse, user: QBUUser?) -> Void in
            print("Login succeeded")
        }
    }
    
    func errorBlock() -> QBRequestErrorBlock {
        return {(response: QBResponse) -> Void in
            print("Error en las credenciales")
        }
    }
    
    func login(userName: String!, password: String!) {
        // Authenticate user
        QBRequest.logInWithUserLogin(userName, password: password, successBlock: self.successBlock(), errorBlock: self.errorBlock())
    }

    
    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if passwordTextF.isFirstResponder() {
            textField.resignFirstResponder()
            validate(self)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        if OneChat.sharedInstance.isConnected() {
            usernameTextF.hidden = true
            passwordTextF.hidden = true
            validateBttn.setTitle("Disconnect", forState: UIControlState.Normal)
        } else {
            if NSUserDefaults.standardUserDefaults().stringForKey(kXMPP.myJID) != "kXMPPmyJID" {
                usernameTextF.text = NSUserDefaults.standardUserDefaults().stringForKey(kXMPP.myJID)
                passwordTextF.text = NSUserDefaults.standardUserDefaults().stringForKey(kXMPP.myPassword)
            }
        }
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
