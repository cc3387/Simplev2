//
//  ViewController.swift
//  Simpleplusplus
//
//  Created by Clement Chan on 10/17/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import UIKit
import Firebase
import Batch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var ref = FIRDatabase.database().reference().child("phone")
        
        if(BatchPush.lastKnownPushToken() != nil){
        
        ref.queryOrdered(byChild: "phoneid").queryEqual(toValue: BatchPush.lastKnownPushToken())
            .observe(.childAdded, with: { snapshot in
                
                if let source = snapshot.value as? [String:AnyObject] {
                    
                    
                    let username = source["username"] as! String
                    let password = source["password"] as! String
                    
                    FIRAuth.auth()!.signIn(withEmail: username, password: password) {
                        (user, error) in
                        
                        if error != nil {
                            // an error occured while attempting login
                            print("Login info is wrong");
                        } else {
                        
                            //Recording the records for adding arrays
                            ProfileLogin.loginemail = username
                            ProfileLogin.password = password
                            ProfileLogin.uid = (user?.uid)!
                            
                            //Load to next storypage
                            self.loadDestinationVC();
                        }
                    
                    }
                }
        })
        }
        else{
        //Do nothing
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load destination to the main profile
    func loadDestinationVC(){
        self.performSegue(withIdentifier: "autologin", sender: nil)
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//Initial construction of Arrays

//Login Information
struct ProfileLogin{
    static var loginemail = "";
    static var password = "";
    static var uid = "";
    static var phoneid = "";
    static var username = "";
};

//Profile Info
var ProfileInfo = [String]();

//Notification List
var FriendNotification = [String]();
var NameNotification = [String]();
var RequestNotification = [String]();

//Notification Accept/Decline
var AcceptDeclineLabel = ""
var Notificationfriend = ""
var Notificationname = ""

//Friend's List
var FriendList = [String]();
var uidList = [String]();
var phoneidList = [String]();
var chatfinalList = [String]();

//Conversation Final
struct convo_final{
    static var friend_Profile_final = "";
    static var chat_check_final = "";
    static var friend_phoneid_final = "";
    static var friend_id_final = "";
    static var notification = "";
    static var finalmsg = "";
};
