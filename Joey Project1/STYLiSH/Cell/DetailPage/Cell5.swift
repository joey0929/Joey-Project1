//
//  Cell5.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/29.
//

import UIKit

class Cell5: UITableViewCell {

    
    @IBOutlet weak var contetView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contetView.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
