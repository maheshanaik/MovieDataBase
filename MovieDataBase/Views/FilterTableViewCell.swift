//
//  FilterTableViewCell.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    static let identifier = "FilterTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureUI(_ title: String?) {
        self.titleLabel.text = title
    }
    
}
