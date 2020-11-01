//
//  NewsViewCellViewModel.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import Foundation

class NewsViewCellViewModel: NewsViewCellViewModelType {
    
    private var news: News
    
    var title: String {
        return news.title
    }
    
    var publicationDate: String {
        return news.publicationDate.components(separatedBy: "+").first ?? "no date"
    }
    
    var category: String {
        return news.category
    }
    
    init(news: News) {
        self.news = news
    }
}
