//
//  AvenueModel.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/02.
//

import Foundation

// MARK: - Welcome
struct AvenueEntity: Codable {
    let meta: Meta
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let address: Address

    enum CodingKeys: String, CodingKey {
        case address
    }
}

// MARK: - Address
struct Address: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String
    let mountainYn, mainAddressNo, subAddressNo, zipCode: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case mountainYn = "mountain_yn"
        case mainAddressNo = "main_address_no"
        case subAddressNo = "sub_address_no"
        case zipCode = "zip_code"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

struct AvenueModel{
    let avenue:String
}

