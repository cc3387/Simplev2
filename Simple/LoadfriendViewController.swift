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
        
        //Add Profile
        ProfileAdd()
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
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
        
        ref.queryOrdered(byChild: "email").queryEqual(toValue: ProfileLogin.loginemail)
            .observe(.childAdded, with: { snapshot in
                
                if let source = snapshot.value as? [String:AnyObject] {
                    
        
                let username = source["username"] as! String
                let location = source["location"] as! String
            
                    ProfileInfo.append(username);
                    ProfileInfo.append(location);
                    
                    print(username)
                    print(location)
                
                }
        })
        
        noteref.queryOrdered(byChild: "user").queryEqual(toValue: ProfileLogin.uid)
            .observe(.childAdded, with: { snapshot in
                
                if let source = snapshot.value as? [String:AnyObject] {
                    let friend = source["friend"] as! String
                    FriendNotification.append(friend);
                }
        })
    }
    
    //Remove Profile Name
    func RemoveOldProfile(){
    ProfileInfo.removeAll()
    }
    
    
    
    
};

