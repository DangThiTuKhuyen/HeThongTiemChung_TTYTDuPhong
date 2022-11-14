//
//  DatePickerCellViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 13/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
final class DatePickerCellViewModel {
    
    // MARK: - Properties
    private(set) var item: RegistionCellItem?
    private(set) var type: RegistionType?

    // MARK: - Initial
    init(item: RegistionCellItem?, type: RegistionType?) {
        self.item = item
        self.type = type
    }

}
