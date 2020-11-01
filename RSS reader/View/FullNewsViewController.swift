//
//  FullNewsViewController.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import UIKit

class FullNewsViewController: UITableViewController {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsFullTextLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    var viewModel: FullNewsViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeAreaAboveTheTable()
        
        guard let viewModel = viewModel else { return }
        self.newsTitleLabel.text = viewModel.title
        self.newsFullTextLabel.text = viewModel.fullText
        self.newsImage.image = viewModel.image
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func removeAreaAboveTheTable() {
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }

}
