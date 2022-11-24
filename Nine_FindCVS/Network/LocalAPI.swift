//
//  LocalAPI.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/24.
//

import Foundation

struct LocalAPI{
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/local/search/category.json"
    
    func getLoaction(mapPoint : MTMapPoint) -> URLComponents{
        var components = URLComponents()
        components.scheme = LocalAPI.scheme
        components.host = LocalAPI.host
        components.path = LocalAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "category_group_code", value: "CS2"),
            URLQueryItem(name: "x", value: "\(mapPoint.mapPointGeo().longitude)"),
            URLQueryItem(name: "y", value: "\(mapPoint.mapPointGeo().latitude)"),
            URLQueryItem(name: "radius", value: "500"),
            URLQueryItem(name: "sort", value: "distance")
        ]
        
        return components
    }
}
