//
//  AddressViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class ProvinceViewModel {

    var addresses: [Address] = []
    var selectedIndexPath: Int = -1

    func getAddressSelected() -> Address {
        return addresses[selectedIndexPath]
    }

    func getDistricts() -> [District] {
        return addresses[selectedIndexPath].districts
    }

    func numberOfRowInSection() -> Int {
        return addresses.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> ProvinceCellViewModel {
        return ProvinceCellViewModel(address: addresses[indexPath.row])
    }
//    func numberOfRowInSectionForDistrict() -> Int {
//        return addresses[selectedIndexPath].districts.count
//    }
//    
//    func viewModelForItem(at indexPath: IndexPath) -> AddressCellViewModel {
//        return AddressCellViewModel(address: addresses[selectedIndexPath].districts[indexPath])
//    }
}

extension ProvinceViewModel {
    func getProvince(completion: @escaping APICompletion) {
        AddressService.getProvince() { [weak self] result in
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
