//
//  ThingModel.swift
//  Demo MVVM
//
//  Created by Hassan Rafique on 8/1/22.
//

import Foundation

struct ThingModel: Decodable {
    let id: String
    let name: String
    
    var isSelected: Bool? = false
}
