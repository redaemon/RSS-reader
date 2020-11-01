//
//  NewsViewCell.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import UIKit

class NewsViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsPubDateLabel: UILabel!
    
    weak var viewModel: NewsViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            newsTitleLabel.text = viewModel.title
            newsPubDateLabel.text = viewModel.publicationDate
        }
    }
    
}
