//
//  FullNewsViewModel.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import Foundation
import UIKit

class FullNewsViewModel: FullNewsViewModelType {
    
    private var news: News
    
    var title: String{
        return news.title
    }
    
    var image: UIImage? {
        return news.image
    }
    
    var fullText: String {
        return news.fullText
    }
    
    init(news: News) {
        self.news = news
    }
}
