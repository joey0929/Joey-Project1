//
//  Cell6.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/29.
//

import UIKit

class Cell6: UITableViewCell {

    
    @IBOutlet weak var nameLabelView: UILabel!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var colorView1: UIView!
    @IBOutlet weak var colorView2: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabelView.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        
        spaceView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
        
//        colorView1.layer.borderColor = UIColor.black.cgColor
//        colorView1.layer.borderWidth = 1.0
//        
//        colorView2.layer.borderColor = UIColor.black.cgColor
//        colorView2.layer.borderWidth = 1.0
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    var previousColorViewRightAnchor: NSLayoutXAxisAnchor? = nil
    
    func addView(colors:[String]) { //用於加到colorview2為基準得做法
        
        let c = colors.count
        for i in 0..<c {
            let colorView = UIView()
            colorView.backgroundColor = UIColor(hex: colors[i])
            colorView.translatesAutoresizingMaskIntoConstraints = false
            //加上黑框
            //colorView.layer.borderColor = UIColor.black.cgColor
            //colorView.layer.borderWidth = 1.0
            colorView2.addSubview(colorView)
            colorView2.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                colorView.widthAnchor.constraint(equalToConstant: 24),
                colorView.heightAnchor.constraint(equalToConstant: 24),
                colorView.centerYAnchor.constraint(equalTo: colorView2.centerYAnchor)
            ])
            
            if let previousAnchor = previousColorViewRightAnchor {
                NSLayoutConstraint.activate([
                    colorView.leadingAnchor.constraint(equalTo: previousAnchor, constant: 8)
                ])
            } else {
                NSLayoutConstraint.activate([
                    colorView.leadingAnchor.constraint(equalTo: colorView2.trailingAnchor,constant: 12)
                ])
            }
            
            // 更新 previousColorViewRightAnchor
            previousColorViewRightAnchor = colorView.trailingAnchor
            
        }
    }
        
        func addView2(colors:[String]) { //用於加到spaceView為基準得做法
            
            let c = colors.count
            for i in 0..<c {
                let colorView = UIView()
                colorView.backgroundColor = UIColor(hex: colors[i])
                colorView.translatesAutoresizingMaskIntoConstraints = false
                colorView.layer.borderColor = UIColor.black.cgColor
                colorView.layer.borderWidth = 1.0
                spaceView.addSubview(colorView)
                spaceView.translatesAutoresizingMaskIntoConstraints = false
                
                
                NSLayoutConstraint.activate([
                    colorView.widthAnchor.constraint(equalToConstant: 24),
                    colorView.heightAnchor.constraint(equalToConstant: 24),
                    colorView.centerYAnchor.constraint(equalTo: spaceView.centerYAnchor)
                ])
                
                if let previousAnchor = previousColorViewRightAnchor {
                    NSLayoutConstraint.activate([
                        colorView.leadingAnchor.constraint(equalTo: previousAnchor, constant: 8)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        colorView.leadingAnchor.constraint(equalTo: spaceView.trailingAnchor,constant: 12)
                    ])
                }
                
                // 更新 previousColorViewRightAnchor
                previousColorViewRightAnchor = colorView.trailingAnchor
                
            }
        
        
        
        
    }
    

}
