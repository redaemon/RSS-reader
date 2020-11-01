//
//  NewsListViewModel.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import Foundation
import UIKit

class NewsListViewModel: NewsListViewModelType {
    
    private var selectedIndexPath: IndexPath?

    var newsList: [News] = []
    
    func numberOfCategories() -> Int {
        
        return newsList.map { $0.category }.unique().count
    }
    
    func getCategoryForFilter(row: Int) -> String? {
        let category = newsList.map { $0.category }.unique()[row]
        return category
    }
    
    func fetchData() {
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let feedParser = FeedParser()
            feedParser.parseFeed(url: "https://www.vesti.ru/vesti.rss")  { (rssItems) in
                DispatchQueue.main.async {
                    self.newsList = rssItems
                    
                }
            }
        }
        
    }
    
    func numberOfNews(isFiltered: Bool, filterCategory: String?) -> Int {
        
        
        if isFiltered == true {
            let filteredArray = newsList.filter {
                $0.category == filterCategory ?? "nil"
            }
            return filteredArray.count
            
        } else {
            return newsList.count
        }
    }

    func cellViewModel(forIndexPath indexPath: IndexPath, isFiltered: Bool, filterCategory: String?) -> NewsViewCellViewModelType? {
        
        
        if isFiltered == true {
            
            let filteredArray = newsList.filter {
                $0.category == filterCategory!
            }
            
            let news = filteredArray[indexPath.row]
            return NewsViewCellViewModel(news: news)
            
        } else {
            let news = newsList[indexPath.row]
            return NewsViewCellViewModel(news: news)
        }
    }

    func viewModelForSelectedRow(isFiltered: Bool, filterCategory: String?) -> FullNewsViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        
        if isFiltered == true {
            
            let filteredArray = newsList.filter {
                $0.category == filterCategory!
            }

            return FullNewsViewModel(news: filteredArray[selectedIndexPath.row])
            
        } else {
 
            return FullNewsViewModel(news: newsList[selectedIndexPath.row])
        }

    }

    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
