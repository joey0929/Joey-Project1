//
//  Cell4.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/29.
//

import UIKit

class Cell4: UITableViewCell {

    
    @IBOutlet weak var labelView1: UILabel!
    @IBOutlet weak var labelView2: UILabel!
    @IBOutlet weak var labelView3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelView1.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        labelView2.textColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)
        labelView3.textColor = UIColor(red: 63/255, green: 58/255, blue: 58/255, alpha: 1)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
