//
//  DistrictViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class DistrictViewModel {

    private(set) var districts: [District]
    var selectedIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    var chooseDistrict: String

    init(districts: [District], chooseDistrict: String) {
        self.districts = districts
        self.chooseDistrict = chooseDistrict
    }

    func numberOfRowInSection() -> Int {
        return districts.count
    }

    func viewModelForItem(at indexPath: IndexPath, selected: Bool = false) -> DistrictCellViewModel {
        return DistrictCellViewModel(district: districts[indexPath.row], selected: selected)
    }

    // from cell to viewController
    func getDistrictSelected() -> String {
        return districts[selectedIndexPath.row].name
    }

    // from viewController to cell
    func setChooseDistrict() {
        var i: Int = -1
        for district in districts {
            i += 1
            if district.name == chooseDistrict {
                selectedIndexPath.row = i
                break
            }
        }
    }
}
