//
//  FeedCell.swift
//  InstaClone
//
//  Created by Pinakpani Mukherjee on 2022/02/23.
//

import UIKit
import Firebase


class FeedCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var imageLikesLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func isLikeClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        if let likeCount = Int(imageLikesLabel.text!){
            let likeStore = ["likes":likeCount + 1] as [String:Any]
            firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
            
        }
        
        
    }
}
