//
//  ProfileDetail.swift
//  Simpleplusplus
//
//  Created by Clement Chan on 10/30/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileDetail: UIViewController {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Location: UILabel!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.endEditing(true)
        super.viewDidLoad()
        self.Name.text = "Name: " + convo_final.friend_Profile_final
        self.Name.textColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
