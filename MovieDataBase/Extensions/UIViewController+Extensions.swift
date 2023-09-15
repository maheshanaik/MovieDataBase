//
//  UIViewController+Extensions.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import Foundation
import UIKit

extension UIViewController {
    static func instansiateFromStoryBoard() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let id = String(describing: self)
        let vc = storyboard.instantiateViewController(withIdentifier: id) as! Self
        return vc
    }
}
