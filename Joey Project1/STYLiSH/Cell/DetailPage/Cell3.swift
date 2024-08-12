//
//  Cell3.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/7/27.
//

import UIKit
import Kingfisher

class Cell3: UITableViewCell ,UIScrollViewDelegate {

    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images: [String] = ["test2", "test3", "test4"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            
        
        scrollView.delegate = self
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(images : [String]) {
        
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        //設定frame 大小
        NSLayoutConstraint.activate([
        scrollView.frameLayoutGuide.heightAnchor.constraint(equalToConstant: 500),
        scrollView.frameLayoutGuide.widthAnchor.constraint(equalToConstant: 393)
        ])
        //設定 content size
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        var previousImageView: UIImageView? = nil
        for (index, _) in images.enumerated() {
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: images[index]))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.frame = CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(imageView)
            
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            
            if let previous = previousImageView {
                // 將當前圖片與前一張圖片水平排列
                imageView.leadingAnchor.constraint(equalTo: previous.trailingAnchor).isActive = true
            } else {
                // 將第一張圖片定到 scrollView 的 leadingAnchor
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            }
            previousImageView = imageView
            
        }
        
        if let lastImageView = previousImageView {
            lastImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        }
        
    
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    
}




