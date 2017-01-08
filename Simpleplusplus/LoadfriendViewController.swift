//
//  LoadfriendViewController.swift
//  Simple
//
//  Created by Clement Chan on 9/23/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import Foundation
import Firebase

class Transfer : UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove Old Profile
        RemoveOldProfile()
        
        //Remove All Array
        RemoveAllArray()
        
        //Add Profile
        ProfileAdd()
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.loadDestinationVC()
        };

        //Load Next StoryBoard
        self.loadDestinationVC()
    }
    
    //Load storyboard afterwards
    func loadDestinationVC(){
        self.performSegue(withIdentifier: "load_menu", sender: nil)
    }
    
    //Add Profile Name
    func ProfileAdd(){
        
        var ref = FIRDatabase.database().reference().child("users")
        var noteref = FIRDatabase.database().reference().child("Notification")
        var friendref = FIRDatabase.database().reference().child("friends").child(ProfileLogin.uid+"_fd")
        
        
        //Login information
        ref.queryOrdered(byChild: "email").queryEqual(toValue: ProfileLogin.loginemail)
            .observe(.childAdded, with: { snapshot in
                
                if let source = snapshot.value as? [String:AnyObject] {
                    
        
                let username = source["username"] as! String
                let location = source["location"] as! String
                    
                    ProfileLogin.username = username;
                    ProfileInfo.append(username);
                    ProfileInfo.append(location);
                    
                    print(username)
                    print(location)
                
                }
        })
        
        //Notification Part
        noteref.queryOrdered(byChild: "user").queryEqual(toValue: ProfileLogin.uid)
            .observe(.childAdded, with: { snapshot in
                
                if let source = snapshot.value as? [String:AnyObject] {
                    let friend = source["friend"] as! String
                    let requestor = source["Requestor"] as! String
                    let username = source["username"] as! String
                    FriendNotification.append(friend)
                    RequestNotification.append(requestor)
                    NameNotification.append(username)
                }
        })
        
        
        //Friend List Part
        let friendQuery = friendref.queryLimited(toLast: 1000000000)
        friendQuery.observe(.childAdded, with:{ snapshot in
            if let source = snapshot.value as? [String:AnyObject] {
                let uid = source["uid"] as! String
                let username = source["username"] as! String
                let phoneid = source["phoneid"] as! String
                let chatfinal = source["chatfinal"] as! String
                FriendList.append(username)
                uidList.append(uid)
                phoneidList.append(phoneid)
                chatfinalList.append(chatfinal)
            }
        })

    }
    
    //Remove Profile Name
    func RemoveOldProfile(){
    ProfileInfo.removeAll()
    }
    
    //Remove All Arrays
    func RemoveAllArray(){
    FriendNotification.removeAll()
    RequestNotification.removeAll()
    NameNotification.removeAll()
    FriendList.removeAll()
    uidList.removeAll()
    phoneidList.removeAll()
    chatfinalList.removeAll()
    }
    
};

