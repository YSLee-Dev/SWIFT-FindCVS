//
//  DetailListCell.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/23.
//

import UIKit

import SnapKit
import Then

class DetailListCell : UITableViewCell{
    let placeName = UILabel().then{
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    let address = UILabel().then{
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    let distance = UILabel().then{
        $0.font = .systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .darkGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.attribute()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailListCell{
    private func attribute(){
        self.backgroundColor = .white
    }
    
    private func layout(){
        [self.placeName, self.address, self.distance]
            .forEach{
                self.contentView.addSubview($0)
            }
        
        self.placeName.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalToSuperview().offset(10)
        }
        
        self.address.snp.makeConstraints{
            $0.top.equalTo(self.placeName.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(self.placeName)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        self.distance.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
}
