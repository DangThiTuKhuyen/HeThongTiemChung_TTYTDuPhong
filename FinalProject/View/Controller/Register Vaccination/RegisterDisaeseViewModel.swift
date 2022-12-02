//
//  RegisterDisaeseViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class RegisterDisaeseViewModel {

    var disaeses: [Disease] = []
    var currentDisaeses: [Disease] = []

    private func getDisaeses(keyWord: String) -> [Disease] {
        if keyWord.isEmpty {
            return disaeses
        } else {
            var data: [Disease] = []
            for disaese in disaeses {
                if let _ = disaese.diseaseName?.range(of: keyWord) {
                    data.append(disaese)
                }
            }
            return data
        }
    }

    func search(keyWord: String) {
        currentDisaeses = getDisaeses(keyWord: keyWord)
    }

    func isShowTableView() -> Bool {
        return currentDisaeses.isNotEmpty
    }

    func numberOfRowInSection() -> Int {
        return currentDisaeses.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> RegisterDiseaseCellViewModel {
        return RegisterDiseaseCellViewModel(disease: currentDisaeses[indexPath.row])
    }

    func getDisaeseSelected(at indexPath: IndexPath) -> [Treatment] {
        return currentDisaeses[indexPath.row].treatments ?? []
    }
    
    func getNameSelected(at indexPath: IndexPath) -> String {
        return currentDisaeses[indexPath.row].diseaseName ?? ""
    }
}

extension RegisterDisaeseViewModel {

    func getDisease(completion: @escaping APICompletion) {
        RegistrationVaccineService.getDisease { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.json))
                return
            }
            switch result {
            case .success(let diseases):
                this.disaeses = diseases
                this.currentDisaeses = diseases
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
