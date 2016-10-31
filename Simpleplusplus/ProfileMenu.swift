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
import MessageUI

class ProfileMenu: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate{
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
    var noteref = FIRDatabase.database().reference().child("Notification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Can Clean up Later
        print(ProfileInfo)
        
        /* Setup delegates */
        self.tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        
        FriendNotification.removeAll()
        NameNotification.removeAll()
        
        noteref.queryOrdered(byChild: "user").queryEqual(toValue: ProfileLogin.uid)
            .observe(.childAdded, with: { snapshot in
                
                if let source = snapshot.value as? [String:AnyObject] {
                    let friend = source["friend"] as! String
                    let name = source["username"] as! String
                    FriendNotification.append(friend)
                    NameNotification.append(name)
                    print(FriendNotification)
                    print(NameNotification)
                }
        })
        
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
        else if(indexPath.section == 2 && FriendNotification.count > 0){
        cell.backgroundColor = UIColor(red: 255, green: 102, blue: 102)
        }
        
        return cell;
    }
    
    //Select Row and action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //Loading Section 1, Add Friend in Menu
        if(indexPath.section == 1 && sections[1].items[indexPath.row] == "Add Friend"){
            loadaddfriend();
        }
        
        //Loading Section 1, Chat in Menu
        if(indexPath.section == 1 && sections[1].items[indexPath.row] == "Chat"){
            loadchat();
        }
        
        //Loading Section 1, Contact Us in Menu
        if(indexPath.section == 1 && sections[1].items[indexPath.row] == "Contact Us"){
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
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
    
    func loadchat(){
        self.performSegue(withIdentifier: "tochat", sender:nil)
    }
    
    
    //Email
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["simplethemeetingsite@gmail.com"])
        mailComposerVC.setSubject("Reporting Abuse, Events and Account issue")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController!, didFinishWith result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
};


//Section Class
class SectionsData {
    
    func getSectionsFromData() -> [Section] {
        
        // you could replace the contents of this function with an HTTP GET, a database fetch request,
        // or anything you like, as long as you return an array of Sections this program will
        // function the same way.
        
        var sectionsArray = [Section]()
        
        let profile = Section(title: "Profile", objects: ProfileInfo)
        let menu = Section(title: "Menu", objects: ["Add Friend", "Chat", "Contact Us", "Terms and Conditions"])
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
