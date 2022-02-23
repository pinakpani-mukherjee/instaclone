//
//  ViewController.swift
//  InstaClone
//
//  Created by Pinakpani Mukherjee on 2022/02/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func isSignInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) {(authdata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", errorMsg: error?.localizedDescription ?? "Undefined Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            let errorMsg = "Please do not leave the email text or password text empty"
            makeAlert(titleInput: "Error!", errorMsg: errorMsg)
        }
    }
    
    
    @IBAction func isSignUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) {(authdata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", errorMsg: error?.localizedDescription ?? "Undefined Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
             
            let errorMsg = "Please do not leave the email text or password text empty"
            makeAlert(titleInput: "Error!", errorMsg: errorMsg)
        }
        
    }
    func makeAlert(titleInput:String, errorMsg:String){
        let alert = UIAlertController(title: titleInput, message:errorMsg , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

