//
//  Notify.swift
//  Simple
//
//  Created by Clement Chan on 10/15/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class Notify: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var MessageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.MessageArray.removeAll()
        self.tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendNotification.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //Read the whole table with sections
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticell", for: indexPath as IndexPath) as UITableViewCell
        
        if(RequestNotification[indexPath.row] == "2"){
                    cell.textLabel?.text = "You have sent a chat request to " + NameNotification[indexPath.row] + "!"
        }
        else if(RequestNotification[indexPath.row] == "1"){
                    cell.textLabel?.text = NameNotification[indexPath.row] + " sent you a chat request!"
        }
        
        self.MessageArray.append((cell.textLabel?.text)!)
        
        cell.backgroundColor = UIColor(red: 204, green: 229, blue: 255)
        
        return cell;
    }
    
    
    //Select Row and action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.MessageArray[indexPath.row] == (NameNotification[indexPath.row] + " sent you a chat request!")){
            AcceptDeclineLabel = "Accept " + NameNotification[indexPath.row] + "'s chat request?"
            Notificationfriend = FriendNotification[indexPath.row]
            Notificationname = NameNotification[indexPath.row]
            FriendAcceptandDecline()
        }
        else{
            //Do Nothing
        }
    }
    
    func FriendAcceptandDecline(){
        self.performSegue(withIdentifier: "AcceptandDecline", sender: nil)
    }
    
    
    
};
