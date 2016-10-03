//
//  ProfileMenu.swift
//  Simple
//
//  Created by Clement Chan on 9/24/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileMenu: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
        
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        
        if(indexPath.section == 0){
            cell.backgroundColor = UIColor(red: 204, green: 255, blue: 204)
        }
        else if(indexPath.section == 1){
            cell.backgroundColor = UIColor(red: 204, green: 229, blue: 255)
        }
        else if(indexPath.section == 2){
            //cell.backgroundColor = UIColor(red: 255, green: 102, blue: 102)
        }
        
        return cell;
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var sections: [Section] = SectionsData().getSectionsFromData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Can Clean up Later
        print(ProfileInfo)
        print(FriendNotification)
        
        /* Setup delegates */
        self.tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].heading
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    //Read the whole table with sections
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
    
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        
        if(indexPath.section == 0){
        cell.backgroundColor = UIColor(red: 204, green: 255, blue: 204)
        }
        else if(indexPath.section == 1){
        cell.backgroundColor = UIColor(red: 204, green: 229, blue: 255)
        }
        else if(indexPath.section == 2){
        //cell.backgroundColor = UIColor(red: 255, green: 102, blue: 102)
        }
        
        return cell;
    }
    
    //Select Row and action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //Loading Section 1, which is Menu
        if(indexPath.section == 1 && sections[1].items[indexPath.row] == "Add Friend" ){
            loadaddfriend();
        }
        
        //Loading Section 2, which is the friend notification
        if(indexPath.section == 2 && sections[2].items[indexPath.row] == "You have received \(FriendNotification.count) Notifications" ){
            loadnotification();
        }
        
    }

    
    @IBAction func Logout(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        loadoriginal();
    
    }
    
    func loadoriginal(){
        self.performSegue(withIdentifier: "original", sender: nil)
    }
    
    func loadaddfriend(){
        self.performSegue(withIdentifier: "add_friend", sender: nil)
    }
    
    func loadnotification(){
        self.performSegue(withIdentifier: "Notification_Table", sender:nil)
    }
    
    
};


class SectionsData {
    
    func getSectionsFromData() -> [Section] {
        
        // you could replace the contents of this function with an HTTP GET, a database fetch request,
        // or anything you like, as long as you return an array of Sections this program will
        // function the same way.
        
        var sectionsArray = [Section]()
        
        let profile = Section(title: "Profile", objects: ProfileInfo)
        let menu = Section(title: "Menu", objects: ["Add Friend", "Chat", "Setting", "Contact Us", "Terms and Conditions"])
        let notification = Section(title: "Notifications", objects: ["You have received \(FriendNotification.count) Notifications"])
        
        
        sectionsArray.append(profile)
        sectionsArray.append(menu)
        sectionsArray.append(notification)
        
        return sectionsArray
    }
}


struct Section {
    
    var heading : String
    var items : [String]
    
    init(title: String, objects : [String]) {
        heading = title
        items = objects
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
