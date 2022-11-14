//
//  ProfileViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 02/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import UIKit

enum ProfileType: Int, CaseIterable {
    case avatar = 0
    case name
    case email
    case identityCard
    case numberPhone
    case gender
    case birthday
    case province
    case district
    case changePass
    case logout
}

struct ProfileCellItem {
    let title: String?
    let value: String?
}

final class ProfileViewModel {

    enum ProfileCellType {
        case avatarCell
        case commonCell

//        init(from index: Int) {
//            switch index {
//            case 1:
//                self = .avatarCell
//            default:
//                self = .commonCell
//            }
//        }
    }

    enum SectionType: Int, CaseIterable {
        case identity = 0
        case infomation
        case security

        var rows: [ProfileType] {
            switch self {
            case .identity:
                return [.avatar, .name, .email, .identityCard]
            case .infomation:
                return [.numberPhone, .gender, .birthday, .province, .district]
            case .security:
                return [.changePass, .logout]
            }
        }
    }


    private(set) var profile: Profile?
//    let userInfo
    private(set) var index: IndexPath = IndexPath(row: 0, section: 0)

    func setupCell(kindOfCell: ProfileType) -> ProfileCellItem? {
        switch kindOfCell {
        case .avatar:
            return ProfileCellItem(title: "", value: profile?.image)
        case .name:
            return ProfileCellItem(title: "Name", value: profile?.name)
        case .email:
            return ProfileCellItem(title: "Email", value: profile?.email)
        case .numberPhone:
            return ProfileCellItem(title: "Phone", value: profile?.phone?.phoneString())
        case .gender:
            return ProfileCellItem(title: "Gender", value: profile?.gender)
        case .birthday:
            return ProfileCellItem(title: "Birthday", value: profile?.birthday)
        case .province:
            return ProfileCellItem(title: "Province", value: profile?.province)
        case .district:
            return ProfileCellItem(title: "District", value: profile?.district)
        case .changePass:
            return ProfileCellItem(title: "Change password", value: "")
        case .logout:
            return ProfileCellItem(title: "Log out", value: "")
        case .identityCard:
            return ProfileCellItem(title: "Identity card", value: profile?.identityCard?.toString())
        }
    }

    func getIndex(_ indexPath: IndexPath) {
        guard let type = ProfileType(rawValue: indexPath.row) else { return }
        index = IndexPath(row: type.rawValue, section: indexPath.section)
    }

    func numberOfRowInSection(inSection section: Int) -> Int {
        let sectionType = SectionType(rawValue: section)
        guard let numberRows = sectionType?.rows.count else { return 0 }
        return numberRows
    }

    func numberOfSection() -> Int {
        return SectionType.allCases.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> Any? {
        let sectionType = SectionType(rawValue: indexPath.section)
        guard let numberRows = sectionType?.rows.count, indexPath.row < numberRows else { return nil }
        guard let type = sectionType?.rows[indexPath.row] else { return nil }
        if type == .avatar {
            let cell = setupCell(kindOfCell: type)
            return NewAvatarCellViewModel(urlString: cell?.value, type: type)
        }
        let cell = setupCell(kindOfCell: type)
        return CommonTableCellViewModel(item: cell, type: type)

    }
}

// MARK: - APIs
extension ProfileViewModel {
    func getProfile(completion: @escaping APICompletion) {
        ProfileService.getProfile { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let profile):
                this.profile = profile
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension Int {
    func phoneString() -> String {
        return "0" + String(self)
    }

    func toString() -> String {
        return String(self)
    }
}

extension Float {
    func toString() -> String {
        return String(self)
    }
}

extension UIButton {
    func downloadImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true

        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(nil)
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
}
