//
//  AllThingsViewController.swift
//  Demo MVVM
//
//  Created by Hassan Rafique on 8/1/22.
//

import UIKit
import Foundation

class AllThingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblThings: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    
    // MARK: - Properties
    private var viewModel = AllThingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        registerCell()
    }
    
    private func setupView() {
        viewModel.delegate = self
        indicatorView.startAnimating()
        viewModel.getAllThings()
        setupNextButtonView()
        
        // MARK: - Update frame because view is not appear yet
        vwTop.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: self.view.frame.size.height * 0.13)
        vwBottom.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: self.view.frame.size.height * 0.12)
        vwTop.addTopViewLayer()
        vwBottom.addBottomRightViewLayer()
    }
}

// MARK: - Method's & Button Action's
extension AllThingsViewController {
    private func registerCell() {
        tblThings.register(UINib(nibName: "ThingTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
    }
    
    
    @IBAction func btnNext_Action(_ sender: UIButton) {
        let selectedThingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectedThingsViewController") as! SelectedThingsViewController
        selectedThingsViewController.viewModel = viewModel
        selectedThingsViewController.modalPresentationStyle = .fullScreen
        self.present(selectedThingsViewController, animated: true)
        
    }
    
    @IBAction func btnAdd_Action(_ sender: UIButton) {
        let addDialog = AddCustomThingViewController(nibName: "AddCustomThingViewController", bundle: nil)
        addDialog.delegate = self
        self.present(addDialog, animated: true)
    }
    
    func setupNextButtonView() {
        if viewModel.selectedThings.count < 3 {
            btnNext.alpha = 0.3
            btnNext.isUserInteractionEnabled = false
        } else {
            btnNext.alpha = 1
            btnNext.isUserInteractionEnabled = true
        }
    }
}


// MARK: - AddCustomThingViewControllerDelegate
extension AllThingsViewController: AddCustomThingViewControllerDelegate {
    func addCustomThing(text: String) {
        viewModel.addCustomThingInList(name: text)
    }
}

// MARK: - MessageViewModelDelegate
extension AllThingsViewController: AllThingsViewModelDelegate {
    func showError(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.indicatorView.stopAnimating()
            self?.showAlertPopup(title: title, message: message)
        }
    }
    
    func didReloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tblThings.reloadData()
            self?.indicatorView.stopAnimating()
        }
    }
    
    func didReloadRow(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.setupNextButtonView()
            self?.tblThings.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didInsertRow(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.tblThings.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableView DataSource & Delegate Methods
extension AllThingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allThingsList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.isSkipLoadAnimaion {
            viewModel.isSkipLoadAnimaion.toggle()
        } else {
            cell.transform = CGAffineTransform(translationX: -(tableView.bounds.size.width), y: 0)
            UIView.animate(withDuration: 0.1 * Double(tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath) ?? 1)) {
                cell.transform = .identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ThingTableViewCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = viewModel.allThingsList[indexPath.row].name
        cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: Constants.appColor).withAlphaComponent((1/CGFloat(indexPath.row + 1)) * 1.7)
        
        cell.imgTick.isHidden = !(viewModel.allThingsList[indexPath.row].isSelected ?? false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.onTapAction(indexPath: indexPath)
    }
}
