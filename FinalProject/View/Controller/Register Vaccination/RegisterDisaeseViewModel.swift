//
//  RegisterDisaeseViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class RegisterDisaeseViewModel {

    let disaeses: [String] = ["Covid", "Sởi", "HPV"]
    var currentDisaeses: [String] = []

    private func getDisaeses(keyWord: String) -> [String] {
        if keyWord.isEmpty {
            return []
        } else {
            var data: [String] = []
            for disaese in disaeses {
                if let _ = disaese.range(of: keyWord) {
                    data.append(disaese)
                }
            }
            return data
        }
    }

    func search(keyWord: String) {
        currentDisaeses = getDisaeses(keyWord: keyWord)
    }
}
