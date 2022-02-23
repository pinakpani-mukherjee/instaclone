//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Pinakpani Mukherjee on 2022/02/21.
//

import UIKit
import Firebase
import FirebaseFirestore
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{


    @IBOutlet weak var uploadComment: UITextField!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadImage.addGestureRecognizer(tapRecognizer)
    }
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func isUploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        if let user = Auth.auth().currentUser{
            let mediaFolder = storageReference.child("media")
            
            if let data = uploadImage.image?.jpegData(compressionQuality: 0.5){
                let uuid = UUID().uuidString
                let imageReference = mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata: nil) { metadata, error in
                    if error != nil{
                        self.makeAlert(titleInput: "Error!", errorMsg: error?.localizedDescription ?? "Undefined Error")
                    }
                    else{
                        imageReference.downloadURL { url, error in
                            if error == nil{
                                
                                let imageUrl = url?.absoluteString
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                var firestoreReference : DocumentReference? = nil
                                
                                let firestorePost = ["imageUrl" : imageUrl!,"postedBy" : user.email!, "postComment": self.uploadComment.text!,"date":FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                                
                                firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                    if error != nil{
                                        self.makeAlert(titleInput: "Error!", errorMsg: error?.localizedDescription ?? "Undefined Error")
                                    }
                                    else{
                                        self.uploadImage.image = UIImage(named: "select.png")
                                        self.uploadComment.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                })
                                
                            }
                        }
                    }
                    }
                }
        }
        else{
            self.makeAlert(titleInput: "User Logged Out!", errorMsg: "You have been logged out, please log back in.")
        }
        
        
        }

    func makeAlert(titleInput:String, errorMsg:String){
        let alert = UIAlertController(title: titleInput, message:errorMsg , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
