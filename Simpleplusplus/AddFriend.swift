//
//  AddFriend.swift
//  Simple
//
//  Created by Clement Chan on 9/26/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import Foundation
import Batch
import Firebase

class AddFriend : UIViewController{
    
    @IBOutlet weak var Email: UITextField!
    
    @IBAction func SendRequest(_ sender: AnyObject) {
        
        var refnoti = FIRDatabase.database().reference().child("Notification")
        
        var ref = FIRDatabase.database().reference().child("users")
        
        ref.queryOrdered(byChild: "email").queryEqual(toValue: self.Email.text!)
            .observe(.childAdded, with: { snapshot in
                
                if let source = snapshot.value as? [String:AnyObject] {
                    
                    let uid = source["uid"] as! String
                    let name = source["username"] as! String
                    
                    var noteset = [
                        "friend": ProfileLogin.uid,
                        "user": uid,
                        "Requestor": "1",
                        "username": ProfileLogin.username
                    ];
                    
                    var noteset1 = [
                        "friend": uid,
                        "user": ProfileLogin.uid,
                        "Requestor": "2",
                        "username": name
                    ];
                    
                    refnoti.child(uid+ProfileLogin.uid).setValue(noteset);
                    refnoti.child(ProfileLogin.uid+uid).setValue(noteset1);
                    
                }
                
            })
        
        //load original function
        loadoriginal();
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    //Load Original storyboard
    func loadoriginal(){
        self.performSegue(withIdentifier: "Request_Send", sender: nil)
    }
    
};
