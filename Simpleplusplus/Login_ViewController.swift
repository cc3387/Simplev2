//
//  Login_ViewController.swift
//  Simple
//
//  Created by Clement Chan on 9/22/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import Foundation
import Firebase
import Batch

class Login : UIViewController{
    
    
    @IBOutlet var Email: UITextField!
    @IBOutlet var Password: UITextField!
    
    @IBAction func Login_Profile(_ sender: AnyObject) {
        
        FIRAuth.auth()!.signIn(withEmail: self.Email.text!, password: self.Password.text!) {
            (user, error) in
            
            if error != nil {
                // an error occured while attempting login
                print("Login info is wrong");
            } else {
                
                //Recording the records for adding arrays
                ProfileLogin.loginemail = self.Email.text!
                ProfileLogin.password = self.Password.text!
                ProfileLogin.uid = (user?.uid)!
                
                if(BatchPush.lastKnownPushToken() != nil){
                    ProfileLogin.phoneid = BatchPush.lastKnownPushToken()
                    let ref = FIRDatabase.database().reference().child("users").child(ProfileLogin.uid)
                    ref.updateChildValues(["Phoneid": ProfileLogin.phoneid])
                }
                else if(BatchPush.lastKnownPushToken() == nil){
                    //Do Nothing
                }
                
                //Load to next storypage
                self.loadDestinationVC();
                
            }
        }
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //Remove All the info when first login
        ProfileInfo.removeAll();
        FriendNotification.removeAll();
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Load destination to the main profile
    func loadDestinationVC(){
        self.performSegue(withIdentifier: "load_friend", sender: nil)
    }
    
};



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


