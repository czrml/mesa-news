//
//  Paginated.swift
//  MesaNews
//
//  Created by Cezar Mauricio on 28/03/21.
//

import Foundation

struct Paginated<Content> {
    let page: Pagination
    let content: [Content]
}

extension Paginated {
    struct Pagination {
        let currentPage: Int
        let pageCount: Int
    
        let items: Int
        let itemsCount: Int
    }
}
