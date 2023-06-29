//
//  MainScreenExtension.swift
//  YanDo
//
//  Created by Александра Маслова on 28.06.2023.
//

import UIKit

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var correctAmount: Int
        
        if showCompletedToDoItems {
            correctAmount = pendingItems.count + completedItems.count
        } else {
            correctAmount = pendingItems.count
        }
        // Добавляем 1 для специальной ячейки внизу
        return correctAmount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        
        // Проверяем, является ли текущая ячейка последней
        if indexPath.row == lastRowIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialCell", for: indexPath) as! SpecialTableViewCell
            // Настройка специальной ячейки
            let maskLayer = CAShapeLayer()
                             maskLayer.path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16, height: 16)).cgPath
                             cell.layer.mask = maskLayer
                     
                     return cell
        } else {
            if showCompletedToDoItems {
                if indexPath.row < completedItems.count {
                    let toDoItem = completedItems[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCompletedCell", for: indexPath) as! CustomCompletedTableViewCell
                    
                    cell.item = toDoItem
                    cell.delegate = self
                    cell.backgroundColor = UIColor(named: "SecondaryBack")
                    
                    return cell
                } else {
                    let toDoItem = pendingItems[indexPath.row - completedItems.count]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
                    
                    cell.item = toDoItem
                    cell.delegate = self
                    cell.backgroundColor = UIColor(named: "SecondaryBack")
                    
                    return cell
                }
            } else {
                let toDoItem = pendingItems[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
                
                cell.item = toDoItem
                cell.delegate = self
                cell.backgroundColor = UIColor(named: "SecondaryBack")
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1 // индекс спец ячейки
        var height: CGFloat = 56
        
        if indexPath.row != lastRowIndex {
            if showCompletedToDoItems {
                if indexPath.row < completedItems.count {
                    let toDoItem = completedItems[indexPath.row]
                    if toDoItem.text.count > 25 && toDoItem.text.count < 50 { height += 20 }
                    if toDoItem.text.count > 50 { height += 42 }
    
                } else {
                    let toDoItem = pendingItems[indexPath.row - completedItems.count]
                    if toDoItem.deadline != nil { height += 10 }
                    if toDoItem.text.count > 25 && toDoItem.text.count < 50 { height += 20 }
                    if toDoItem.text.count > 50 { height += 42 }
                }
                
            } else {
                let toDoItem = pendingItems[indexPath.row]
                if toDoItem.deadline != nil { height += 10 }
                if toDoItem.text.count > 25 && toDoItem.text.count < 50 { height += 20 }
                if toDoItem.text.count > 50 { height += 42 }
            }
        }
        
        return height / Aligners.modelHight * Aligners.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1

        if indexPath.row == lastRowIndex {
            let vc = TaskScreenViewController(toDoItem: nil)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: nil)
        } else {
            let toDoItem: ToDoItem
            if showCompletedToDoItems {
                if indexPath.row < completedItems.count {
                    toDoItem = completedItems[indexPath.row]
                } else {
                    toDoItem = pendingItems[indexPath.row - completedItems.count]
                }
            } else {
                toDoItem = pendingItems[indexPath.row]
            }

            let vc = TaskScreenViewController(toDoItem: toDoItem)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: nil)
        }
    }

}
