//
//  DataCollectionViewCell.swift
//  Testing
//
//  Created by Arun Cheela on 23/11/21.
//

import UIKit

class DataCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var description_lbl: UILabel!
    @IBOutlet weak var title_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.layer.cornerRadius = 6
        // Initialization code
    }

}
