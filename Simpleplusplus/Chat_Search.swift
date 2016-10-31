//
//  Chat_Search.swift
//  Simpleplusplus
//
//  Created by Clement Chan on 10/27/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import Foundation
import Foundation
import Firebase

class Chat_Search: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var selectedname: String = "";
    var data = uidList
    var data1 = FriendList
    var filtered:[String] = []
    var filtered1:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        self.tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data1.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        else{
            return data1.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
        
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        }
        else {
            cell.textLabel?.text = data1[indexPath.row]
        }
        
        cell.backgroundColor = UIColor(red: 255, green: 255, blue: 204)
        
        
        return cell;
        
    }
    
    //Select Row in index Path
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(searchActive){
        
        //Set all the information for conversation final accordingly
            var count = 0;
            var countfinal = 0;
            let selectedname = filtered[indexPath.row]
            print("This is selectedname " + selectedname)
            
            for index in data1{
                if(index == selectedname){
                    countfinal = count;
                }
                count += 1;
            }

        convo_final.friend_id_final = data[countfinal]
        print("This is final id " + convo_final.friend_id_final)
            
        var ref = FIRDatabase.database().reference().child("friends").child(ProfileLogin.uid + "_fd")
        
        ref.queryOrdered(byChild: "uid").queryEqual(toValue: convo_final.friend_id_final)
                .observe(.childAdded, with: { snapshot in
                    
                    if let source = snapshot.value as? [String:AnyObject] {
                        
                        
                        let username = source["username"] as! String
                        let phoneid = source["phoneid"] as! String
                        let chatfinal = source["chatfinal"] as! String
                        
                        convo_final.friend_Profile_final = username
                        convo_final.friend_phoneid_final = phoneid
                        convo_final.chat_check_final = chatfinal
                        
                        print(convo_final.friend_Profile_final)
                        print(convo_final.friend_id_final)
                        print(convo_final.friend_phoneid_final)
                        print(convo_final.chat_check_final)
                    }
        })

        loadDestinationChat()
            
        }
        else{
            
            convo_final.friend_id_final = data[indexPath.row]
            
            var ref = FIRDatabase.database().reference().child("friends").child(ProfileLogin.uid + "_fd")
            
            ref.queryOrdered(byChild: "uid").queryEqual(toValue: convo_final.friend_id_final)
                .observe(.childAdded, with: { snapshot in
                    
                    if let source = snapshot.value as? [String:AnyObject] {
                        
                        
                        let username = source["username"] as! String
                        let phoneid = source["phoneid"] as! String
                        let chatfinal = source["chatfinal"] as! String
                        
                        convo_final.friend_Profile_final = username
                        convo_final.friend_phoneid_final = phoneid
                        convo_final.chat_check_final = chatfinal
                        
                        print(convo_final.friend_id_final)
                        print(convo_final.friend_Profile_final)
                        print(convo_final.friend_phoneid_final)
                        print(convo_final.chat_check_final)
                    }
            })
        
        loadDestinationChat()
        }
    }
    
    //Load storyboard afterwards
    func loadDestinationChat(){
        self.performSegue(withIdentifier: "chatdetail", sender: nil)
    }
    
    
};
