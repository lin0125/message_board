//
//  MainTableViewCell.swift
//  realmtest
//
//  Created by imac-2437 on 2023/7/12.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel?
    @IBOutlet weak var label2: UILabel?
    
    static let identifier = "MainTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
