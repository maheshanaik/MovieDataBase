//
//  SectionHeaderView.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "SectionHeaderView"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    func configureUI(_ title: String) {
        titleLabel.text = title
    }
    
    func updateImage(isExpanded: Bool) {
        if isExpanded {
            arrowImageView.image = UIImage(named: "downArrow")
        } else {
            arrowImageView.image = UIImage(named: "rightArrow")
        }
    }
}
