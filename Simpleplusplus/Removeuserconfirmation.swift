//
//  Removeuserconfirmation.swift
//  Simpleplusplus
//
//  Created by Clement Chan on 10/30/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import UIKit
import Firebase

class Removeuser: UIViewController {
    
    @IBAction func YesButton(_ sender: AnyObject) {
        var ref = FIRDatabase.database().reference()
        ref.child("Conversation").child(convo_final.finalmsg).removeValue()
        loadDestinationVC()
    }
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.endEditing(true)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load storyboard afterwards
    func loadDestinationVC(){
        self.performSegue(withIdentifier: "Remove", sender: nil)
    }
}
