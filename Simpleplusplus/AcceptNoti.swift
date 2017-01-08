//
//  AcceptNoti.swift
//  Simple
//
//  Created by Clement Chan on 10/15/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AcceptNoti: UIViewController{

    @IBOutlet weak var AcceptLabel: UILabel!
    
    @IBAction func Accept(_ sender: AnyObject) {
        var ref = FIRDatabase.database().reference()
        ref.child("Notification").child(ProfileLogin.uid + Notificationfriend).removeValue()
        ref.child("Notification").child(Notificationfriend + ProfileLogin.uid).removeValue()
        ref.child("Conversation").child(ProfileLogin.uid + Notificationfriend).childByAutoId().setValue("")
        
        var friendone = [
            "uid" : ProfileLogin.uid,
            "username": ProfileLogin.username,
            "phoneid": ProfileLogin.phoneid,
            "chatfinal": "1"
        ]
        
        var friendtwo = [
            "uid" : Notificationfriend,
            "username": Notificationname,
            "phoneid": ProfileLogin.phoneid,
            "chatfinal": "2"
        ]
        
        ref.child("friends").child(ProfileLogin.uid + "_fd").childByAutoId().setValue(friendtwo)
        ref.child("friends").child(Notificationfriend + "_fd").childByAutoId().setValue(friendone)
        loadDestinationVC()
    }
    
    @IBAction func Decline(_ sender: AnyObject) {
        var ref = FIRDatabase.database().reference()
        ref.child("Notification").child(ProfileLogin.uid + Notificationfriend).removeValue()
        ref.child("Notification").child(Notificationfriend + ProfileLogin.uid).removeValue()
        loadDestinationVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.AcceptLabel.text = AcceptDeclineLabel
        self.AcceptLabel.textColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load storyboard afterwards
    func loadDestinationVC(){
        self.performSegue(withIdentifier: "tomenu", sender: nil)
    }
}
