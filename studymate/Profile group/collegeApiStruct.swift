//
//  collegeApiStruct.swift
//  studymate
//
//  Created by Haonan Wang on 4/22/22.
//

import Foundation

// get initial, most broad data
struct Initial: Decodable {
    let success: Bool
    let collegeList: [CollegeInfo]
}

// struct for represent each dictionary of collegeList
struct CollegeInfo: Decodable {
    let id: String
    let unitId: Int
    let name: String
    let city: String
    let state: String
}
