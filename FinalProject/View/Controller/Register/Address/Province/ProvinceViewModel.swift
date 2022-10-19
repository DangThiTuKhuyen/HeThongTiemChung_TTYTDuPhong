//
//  AddressViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class ProvinceViewModel {

    private(set) var addresses: [Address] = []
    var selectedIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    var chooseProvince: String

    init(chooseProvince: String) {
        self.chooseProvince = chooseProvince
    }

    func getAddressSelected() -> Address {
        return addresses[selectedIndexPath.row]
    }

    func numberOfRowInSection() -> Int {
        return addresses.count
    }

    func setChooseProvince() {
        var i: Int = -1
        for address in addresses {
            i += 1
            print(i)
            if address.province == chooseProvince {
                selectedIndexPath.row = i
                break
            }
        }
    }

    func viewModelForItem(at indexPath: IndexPath, selected: Bool = false) -> ProvinceCellViewModel {
        return ProvinceCellViewModel(address: addresses[indexPath.row], selected: selected)
    }
}

extension ProvinceViewModel {
    func getProvince(completion: @escaping APICompletion) {
        AddressService.getProvince { [weak self] result in
            guard let this = self else {
                completion(.failure(Errors.initFailure))
                return
            }
            switch result {
            case .success(let addresses):
                this.addresses = addresses
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
