//
//  HomeDestinationItem.swift
//  Bookly
//
//  Created by user938962 on 4/12/26.
//

import Foundation

struct HomeDestinationItem: Identifiable, Hashable {
    let id: UUID
    let destination: Destination
    let title: String
    let country: String
    let description: String
    let imageURL: URL?
}
