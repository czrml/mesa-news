//
//  PaginatedResponse.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 27/03/21.
//  Copyright © 2021 Mesa news. All rights reserved.
//

import Foundation

struct PaginatedResponse<Content: Decodable & DomainConvertibleType> {
    let pagination: Pagination
    let data: [Content]
}

extension PaginatedResponse: Decodable { }

extension PaginatedResponse: DomainConvertibleType {
    var asDomain: Paginated<Content.DomainType>? {
        guard let page = pagination.asDomain else { return nil }
        
        return Paginated(page: page,
                         content: data.compactMap(\.asDomain))
    }
}

extension PaginatedResponse {
    struct Pagination {
        let currentPage: Int
        let perPage: Int
        let totalPages: Int
        let totalItems: Int
    }
}

extension PaginatedResponse.Pagination: Decodable {
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case perPage = "per_page"
        case totalPages = "total_pages"
        case totalItems = "total_items"
    }
}

extension PaginatedResponse.Pagination: DomainConvertibleType {
    var asDomain: Paginated<Content.DomainType>.Pagination? {
        Paginated.Pagination(currentPage: currentPage,
                             pageCount: totalPages,
                             items: perPage,
                             itemsCount: totalItems)
    }
}
