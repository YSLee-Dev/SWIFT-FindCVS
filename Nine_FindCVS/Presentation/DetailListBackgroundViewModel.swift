//
//  DetailListBackgroundViewModel.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/23.
//

import Foundation

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel{
    // INPUT
    let shouldHideLabel = PublishRelay<Bool>()
    
    // OUTPUT
    let isLabelHidden : Signal<Bool>
    
    init(){
        self.isLabelHidden = self.shouldHideLabel
            .asSignal(onErrorJustReturn: true)
    }
}
