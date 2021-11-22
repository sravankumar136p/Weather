//
//  HeaderCell.swift
//  Testing
//
//  Created by Arun Cheela on 23/11/21.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var description_Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        name_lbl.textAlignment = .center
        description_Lbl.textAlignment = .center
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
