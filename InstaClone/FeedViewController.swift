//
//  FeedViewController.swift
//  InstaClone
//
//  Created by Pinakpani Mukherjee on 2022/02/21.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
        // Do any additional setup after loading the view.
    }
    
    func getDataFromFirestore(){
        let firestoreDatabase = Firestore.firestore()

        firestoreDatabase.collection("Posts").order(by: "date",descending: true).addSnapshotListener { snapshot, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", errorMsg: error?.localizedDescription ?? "Undefined Error")
                }
                else{
                    if snapshot?.isEmpty != true && snapshot != nil{
                        self.userEmailArray.removeAll(keepingCapacity: false)
                        self.userCommentArray.removeAll(keepingCapacity: false)
                        self.likeArray.removeAll(keepingCapacity: false)
                        self.userImageArray.removeAll(keepingCapacity: false)
                        self.documentIdArray.removeAll(keepingCapacity: false)
                        for document in  snapshot!.documents{
                            if let postedBy = document.get("postedBy") as? String {
                                self.userEmailArray.append(postedBy)
                                if let postComment = document.get("postComment") as? String{
                                    self.userCommentArray.append(postComment)
                                    if let imageURL = document.get("imageUrl") as? String{
                                        self.userImageArray.append(imageURL)
                                        if let likes = document.get("likes") as? Int{
                                            self.likeArray.append(likes)
                                            if let documentId = document.documentID as? String{
                                                self.documentIdArray.append(documentId)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instaCell", for: indexPath) as! FeedCell
        
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.imageLikesLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        //let urlstring = await getDownloadableURL(imageURL: userImageArray[indexPath.row])
        print(" The URL string is \(userImageArray[indexPath.row])")
        cell.userImage.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]), completed: nil)
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        return cell
        
        
    }
    
    func makeAlert(titleInput:String, errorMsg:String){
        let alert = UIAlertController(title: titleInput, message:errorMsg , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

