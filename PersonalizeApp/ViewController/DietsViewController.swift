//
//  DietsViewController.swift
//  PersonalizeApp
//
//  Created by Pyae Phyo Oo on 12/10/2024.
//

import Foundation
import UIKit
import Combine

class DietsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var bindings = Set<AnyCancellable>()
    var viewModel = DietViewModel()
    var dietsList: [DietsModelData]?
    var selectedData: [DietsModelData] = []
    var hearthConcernsList: [HearthConcernsModelData] = []
    var totalTime = 4 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUptableView()
        getDietsList()
        getProgressBar()
    }
    
    func setUptableView() {
        tableView.registerForCells(cells: DietsTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getProgressBar() {
        progressBar.progress = Float(totalTime - 2) / Float(totalTime)
    }
    
    func getDietsList() {
        let noneData = DietsModelData(id: 0, name: "None", tool_tip: "")
        viewModel.getDietsData()
        viewModel.getDietsList.sink { [weak self] dietsList in
            if dietsList.count > 0 {
                self?.dietsList = dietsList
                self?.dietsList?.insert(noneData, at: 0)
            } else {
                self?.dietsList?.append(noneData)
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        .store(in: &bindings)
    }
    
    @IBAction func didTappedBack(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    
    @IBAction func didTappedNext(_ sender: Any) {
        if selectedData.count > 0  {
            let storyboard: UIStoryboard = UIStoryboard(name: "AllergiesViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AllergiesViewController") as! AllergiesViewController
            vc.modalPresentationStyle = .fullScreen
            vc.hearthConcernsList = hearthConcernsList
            if let _ = selectedData.firstIndex(where: { $0.id == 0 }) {
                vc.dietsList = []
            } else {
                vc.dietsList = selectedData
            }
            self.present(vc, animated: false)
        } else {
            self.showToast(message: "Please select One Or More")
        }
    }
    
}

extension DietsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dietsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReuseCell(type: DietsTableViewCell.self, indexPath: indexPath)
        cell.name.text = dietsList?[indexPath.row].name
        cell.diets = dietsList?[indexPath.row]
        cell.index = indexPath.row
        cell.infoBtn.isHidden = indexPath.row == 0
        DispatchQueue.main.async {
            if let _ = self.selectedData.firstIndex(where: { $0.id == 0 }) {
                cell.wholeBtn.isEnabled = indexPath.row == 0
                cell.wholeBtn.isSelected = indexPath.row == 0
            } else {
                cell.wholeBtn.isEnabled = true
            }
        }
        cell.delegte = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension DietsViewController: DietsTableViewCellProtocol {
    
    func didTappedInfo(sender: UIButton, index: Int) {
        let popoverContent = PopoverViewController()
//        popoverContent.label.text = "gg"
        presentPopover(self, popoverContent, sender: sender, size: CGSize(width: 160, height: 45), arrowDirection: .left)
    }
    
    
    func toAdd(index: Int, diets: DietsModelData) {
        if selectedData.count == 0 {
            selectedData.append(diets)
        } else {
            if let _ = selectedData.firstIndex(where: { $0.id != 0 }) {
                selectedData.append(diets)
            }
        }
        if index == 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func toRemove(index: Int, diets: DietsModelData) {
        let id = dietsList?[index].id
        if let foundIndex = selectedData.firstIndex(where: { $0.id == id }) {
            selectedData.remove(at: foundIndex)
        }
        if index == 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
