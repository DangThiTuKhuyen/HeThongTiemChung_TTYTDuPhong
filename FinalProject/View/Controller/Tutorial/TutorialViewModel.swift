//
//  TutorialViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 05/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class TutorialViewModel {

    var titles = ["Wash Your Hands", "Wear Mask", "Use Nose Rag"]
    var descs = ["Clean your hands often. Use soap and water, or an alcohol-based hand rub.", "Cover mouth and nose with mask & no gaps between your face and the mask.", "Cover your nose and mouth with your bent elbow or a tissue when you cough."]
    var images = ["wash_hand", "wear_mask", "use_nose_rag"]
    var titleButtons = ["Next step", "Next step", "Start now"]

    func showTitle(at page: Int) -> String {
        return titles[page]
    }

    func showDescs(at page: Int) -> String {
        return descs[page]
    }

    func showImage(at page: Int) -> String {
        return images[page]
    }

    func numberOfPage() -> Int {
        return titles.count
    }

    func showTitleOfButton(at page: Int) -> String {
        return titleButtons[page]
    }
}
