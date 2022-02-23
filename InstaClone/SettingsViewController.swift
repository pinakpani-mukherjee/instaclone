//
//  SettingsViewController.swift
//  InstaClone
//
//  Created by Pinakpani Mukherjee on 2022/02/21.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
            
        }
        catch{
            
        }
    }


}
