//
//  BusinessCell.swift
//  Yelp
//
//  Created by Pat Khai on 9/15/18.
//  Copyright © 2018 Pat Khai. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var costView: UILabel!
    @IBOutlet weak var resturantTypeView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var ratingReviews: UILabel!
    @IBOutlet weak var distanceView: UILabel!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    var business: Business! {
        didSet {
            nameView.text = business.name
            previewImageView.setImageWith(business.imageURL!)
            ratingReviews.text = "\(business.reviewCount!) Reviews"
            ratingView.image = business.ratingImage
            addressView.text = business.address
            resturantTypeView.text = business.categories
            distanceView.text = business.distance
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        previewImageView.layer.cornerRadius = 3
        previewImageView.clipsToBounds = true
        
        nameView.preferredMaxLayoutWidth = nameView.frame.size.width
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameView.preferredMaxLayoutWidth = nameView.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
