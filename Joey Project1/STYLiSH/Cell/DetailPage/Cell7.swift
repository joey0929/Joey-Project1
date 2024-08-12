//
//  Cell7.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/29.
//

import UIKit

class Cell7: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        contentLabel.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        spaceView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
