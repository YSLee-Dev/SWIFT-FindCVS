//
//  DetailListBackgroundView.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/23.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class DetailListBackgroundView : UIView{
    let bag = DisposeBag()
    let statusLabel = UILabel().then{
        $0.text = "지도 주변에 편의점이 없습니다."
        $0.textColor = .darkGray
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attribute()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailListBackgroundView{
    private func layout(){
        self.addSubview(self.statusLabel)
        self.statusLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    private func attribute(){
        self.backgroundColor = .white
    }
    
    func bind(viewModel : DetailListBackgroundViewModel){
        viewModel.isLabelHidden
            .emit(to: self.statusLabel.rx.isHidden)
            .disposed(by: self.bag)
    }
}
