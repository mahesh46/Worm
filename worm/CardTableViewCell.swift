//
//  CardTableViewCell.swift
//  Worm
//
//  Created by Administrator on 27/03/2018.
//  Copyright © 2018 mahesh lad. All rights reserved.
//

import UIKit
import AVKit

class CardTableViewCell: UITableViewCell {
 
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var playerView: PlayerView!
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var captionView: UIView!
    
    @IBOutlet weak var nameTextLabel: UILabel!
    
    @IBOutlet weak var camptionTextLabel: UILabel!
    
    @IBOutlet weak var videoImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
