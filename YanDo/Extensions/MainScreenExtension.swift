//
//  MainScreenExtension.swift
//  YanDo
//
//  Created by Александра Маслова on 28.06.2023.
//

import UIKit

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.itemsCollection.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == fileCache.itemsCollection.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialCell", for: indexPath) as! SpecialTableViewCell
            
            let maskLayer = CAShapeLayer()
                    maskLayer.path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16, height: 16)).cgPath
                    cell.layer.mask = maskLayer
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
            
            let toDoItem = Array(fileCache.itemsCollection.values)[indexPath.row]
            cell.item = toDoItem
            
            cell.backgroundColor = UIColor(named: "SecondaryBack")
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 56
        
        if indexPath.row == fileCache.itemsCollection.count {
            // Размер для специальной ячейки
            return height / Aligners.modelHight * Aligners.height
        } else {
            
            let toDoItem = Array(fileCache.itemsCollection.values)[indexPath.row]
            // Рассчитываем высоту ячейки в зависимости от наполнения
            if toDoItem.deadline != nil { height += 10 }
            if toDoItem.text.count > 25 && toDoItem.text.count < 50 { height += 20 }
            if toDoItem.text.count > 50 { height += 42 }
            
            return height / Aligners.modelHight * Aligners.height
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let item = Array(fileCache.itemsCollection.values)[indexPath.row]
        let vc = TaskScreenViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
}

