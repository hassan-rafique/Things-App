//
//  AllThingsViewModel.swift
//  Demo MVVM
//
//  Created by Hassan Rafique on 8/1/22.
//

import Foundation

protocol AllThingsViewModelDelegate {
    func showError(title: String, message: String)
    func didReloadTableView()
    func didReloadRow(indexPath: IndexPath)
    func didInsertRow(indexPath: IndexPath)

}

class AllThingsViewModel {
    
    // MARK: - Properties
    var delegate: AllThingsViewModelDelegate?
    var isSkipLoadAnimaion: Bool = false
    private (set) var allThingsList: [ThingModel] = []

    var selectedThings: [ThingModel] {
        allThingsList.filter { obj in
            obj.isSelected ?? false
        }
    }
    
    func onTapAction(indexPath: IndexPath) {
        allThingsList[indexPath.row].isSelected = !(allThingsList[indexPath.row].isSelected ?? false)
        
        isSkipLoadAnimaion = true
        delegate?.didReloadRow(indexPath: indexPath)
    }
    
    func addCustomThingInList(name: String) {
        let model = ThingModel(id: "\(allThingsList.count+1)", name: name)
        self.allThingsList.append(model)
        self.delegate?.didInsertRow(indexPath: IndexPath(row: allThingsList.count-1, section: 0))
    }
    
    func getAllThings() {
        guard NetworkManager.sharedInstance.isConnected else {
            delegate?.showError(title: "No Internet Connection", message: "Please check your internet connection and try again later")
            return
        }
        
        NetworkManager.sharedInstance.sendGetRequest(url: Constants.apiBaseUrl + "things", headers: [:]) { [weak self] response in
            switch response.result {
            case .failure(let error):
                self?.delegate?.showError(title: "Error", message: error.localizedDescription)
            case .success(let responseData):
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode([ThingModel].self, from: responseData)
                    self?.allThingsList.removeAll()
                    self?.allThingsList.append(contentsOf: decodedResponse)
                    self?.delegate?.didReloadTableView()
                } catch let jsonError {
                    print("Failure Response \(jsonError)")
                    self?.delegate?.showError(title: "Error", message: jsonError.localizedDescription)
                }
            }
        }
    }
}
