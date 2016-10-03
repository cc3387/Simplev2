import Foundation
import Firebase
import Batch

class Register : UIViewController{

    @IBOutlet var Name: UITextField!
    @IBOutlet var Email: UITextField!
    @IBOutlet var Password: UITextField!
    @IBOutlet var Location: UITextField!
    
    var ref = FIRDatabase.database().reference()
    var uid = "";
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func Send(_ sender: AnyObject) {
        
      FIRAuth.auth()!.createUser(withEmail: self.Email.text!, password: self.Password.text!) { (user, error) in
        
            if error != nil {
                // There was an error creating the account
                print("There was an error in creating")
            } else {
                let uid = user?.uid
                var phoneid = ""
                self.uid = uid!;
                
                
                if(BatchPush.lastKnownPushToken() != nil){
                    phoneid = BatchPush.lastKnownPushToken()
                }
                
                print("Successfully created user account with uid: \(uid)")
                
                //Sending info to databse
                var userref = self.ref.child("friends")
                
                var profile = [
                    //"title": register_info.user_id,
                    "username": self.Name.text!,
                    "password": self.Password.text!,
                    "email": self.Email.text!,
                    "location": self.Location.text!,
                    "Phoneid" : phoneid,
                    "uid": self.uid
                ];
                
                //Setting Value in database
                self.ref.child("users").child(byAppendingPath: self.uid as String).setValue(profile)
            }
            
        }
        
        loadDestinationVC()
    
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Load storyboard with identifier
    func loadDestinationVC(){
        self.performSegue(withIdentifier: "RegComplete", sender: nil)
    }
    
};
