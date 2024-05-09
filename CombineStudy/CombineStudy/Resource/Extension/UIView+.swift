//
//  UIView+.swift
//  CombineStudy
//
//  Created by 이명진 on 5/9/24.
//

import UIKit

extension UIView{
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
