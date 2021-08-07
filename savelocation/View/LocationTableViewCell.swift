//
//  LocationTableViewCell.swift
//  savelocation
//
//  Created by admin on 06/08/21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationAdd : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
