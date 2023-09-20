//
//  CategoryCellViewModel.swift
//  Reverie
//
//  Created by 이예인 on 2023/08/25.
//

import UIKit

struct CategoryCellViewModel {
    var title: String
    var isSelected = false
    
    var textColor: UIColor {
        isSelected ? .black : .lightGray
    }
}
