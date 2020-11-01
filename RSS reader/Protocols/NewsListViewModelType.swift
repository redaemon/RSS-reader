//
//  NewsListViewModelType.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import Foundation

protocol NewsListViewModelType {
    func numberOfNews(isFiltered: Bool, filterCategory: String?) -> Int
    func numberOfCategories() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath, isFiltered: Bool, filterCategory: String?) -> NewsViewCellViewModelType?
    
    func viewModelForSelectedRow(isFiltered: Bool, filterCategory: String?) -> FullNewsViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
    
    func fetchData()
    func getCategoryForFilter(row: Int) -> String?
}
