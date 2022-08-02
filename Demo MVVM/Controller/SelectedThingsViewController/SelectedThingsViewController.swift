//
//  SelectedThingsViewController.swift
//  Demo MVVM
//
//  Created by Hassan Rafique on 8/1/22.
//

import UIKit

class SelectedThingsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var lblSelectedThingHeading: UILabel!
    @IBOutlet weak var lblSelectedThingName: UILabel!
    @IBOutlet weak var tblThings: UITableView!

    // MARK: - Properties
    var viewModel: AllThingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        registerCell()
    }
 
    private func setupView() {
        // MARK: - Update frame because view is not appear yet
        vwTop.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: self.view.frame.size.height * 0.13)
        vwBottom.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9, height: self.view.frame.size.height * 0.12)
        vwTop.addTopViewLayer()
        vwBottom.addBottomLeftViewLayer()
    }
    
    private func registerCell() {
        tblThings.register(UINib(nibName: "ThingTableViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
    }

    @IBAction func btnBack_Action(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}

// MARK: - UITableView DataSource & Delegate Methods
extension SelectedThingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedThings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ThingTableViewCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = viewModel.allThingsList[indexPath.row].name
        cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: Constants.appColor).withAlphaComponent((1/CGFloat(indexPath.row + 1)) * 1.5)
        
        cell.imgTick.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        updateSelectedThing(model: viewModel.selectedThings[indexPath.row])
    }
    
    func updateSelectedThing(model: ThingModel) {
        lblSelectedThingHeading.alpha = 0
        lblSelectedThingName.isHidden = true
        lblSelectedThingName.text = model.name
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent) { [weak self] in
            self?.lblSelectedThingHeading.alpha = 1
            self?.lblSelectedThingName.isHidden = false
        }

    }
}
