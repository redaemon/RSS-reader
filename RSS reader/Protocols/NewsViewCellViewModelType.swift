//
//  NewsViewCellViewModelType.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import Foundation

protocol NewsViewCellViewModelType: class {
    var title: String { get }
    var publicationDate: String { get }
    var category: String { get }
}
