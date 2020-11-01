//
//  NewsListViewController.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import UIKit

class NewsListViewController: UITableViewController {

    var viewModel: NewsListViewModelType?
    
    var selectedGroup: String?
    
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    @IBOutlet weak var cancelCategoryChangeButton: UIBarButtonItem!
    
    var toolBar = UIToolbar()
    var pickerView  = UIPickerView()
    var pickerViewIsOpen: Bool = false
    var isFiltered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = NewsListViewModel()
        
        cancelCategoryChangeButton.isEnabled = false
        cancelCategoryChangeButton.tintColor = .clear
        
        viewModel?.fetchData()
        loadingDataWithDelay()
    
    }
    
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        
        viewModel?.fetchData()
        tableView.reloadData()
        sender.endRefreshing()
    }
    

    @IBAction func categoryButtonTapped(_ sender: Any) {
        
        guard pickerViewIsOpen == false else { return onDoneButtonTapped() }
        
        createPickerView()
        pickerViewIsOpen = true

    }
    
    @IBAction func cancelCategoryChange(_ sender: Any) {
        
        if isFiltered == true {
            cancelCategoryChangeButton.isEnabled = false
            cancelCategoryChangeButton.tintColor = .clear
            toolBar.removeFromSuperview()
            pickerView.removeFromSuperview()
            isFiltered = false
            pickerViewIsOpen = false
            
            self.tableView.reloadData()
        }
    }

    func loadingDataWithDelay() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            activityIndicator.stopAnimating()
            self.tableView.reloadData()
            
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfNews(isFiltered: isFiltered, filterCategory: selectedGroup) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NewsViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath, isFiltered: isFiltered, filterCategory: selectedGroup)

        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        
        performSegue(withIdentifier: "showNews", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "RSS vesti.ru"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let viewModel = viewModel else { return }
        
        if identifier == "showNews" {
            
            if let destinationNavigation = segue.destination as? UINavigationController{
                let targetController = destinationNavigation.topViewController as! FullNewsViewController
                targetController.viewModel = viewModel.viewModelForSelectedRow(isFiltered: isFiltered, filterCategory: selectedGroup)
            }
        }
    }

}

// MARK: - Picker View

extension NewsListViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.numberOfCategories() ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard viewModel != nil else { return "no categories"}
        return viewModel?.getCategoryForFilter(row: row)
        //return NewsListViewModel().newsList.map { $0.category }[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard viewModel != nil else { return }
        selectedGroup = viewModel?.getCategoryForFilter(row: row)
    }
    
    func createPickerView() {

        pickerView = UIPickerView.init()
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.autoresizingMask = .flexibleWidth
        pickerView.contentMode = .center
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        toolBar = UIToolbar.init()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.backgroundColor = .systemGray
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
        toolBar.setItems([doneButton], animated: true)
        view.addSubview(pickerView)
        view.addSubview(toolBar)

        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -pickerView.frame.height),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 40),
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: pickerView.topAnchor),
        ])
        
    }

    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        pickerView.removeFromSuperview()
        isFiltered = true
        cancelCategoryChangeButton.isEnabled = true
        cancelCategoryChangeButton.tintColor = .black
        pickerViewIsOpen = false
        self.tableView.reloadData()
    }

}
