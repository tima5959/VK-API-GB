//
//  FriendsTableViewController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 26.07.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    // Значение nil, говорит что результаты поиска будут отображены на самом Контроллере
    // Если мы хотим показывать результаты на другом контроллере, то вместо nil нужно установить другой контроллер
    let searchController = UISearchController(searchResultsController: nil)
    
    private let cellIdentifire = "cell"
    private let segueIdentifire = "detailFriendsTableViewSegue"
    var users: [String] = [
        "Шибалкина Юлия",
        "Ратников Потап",
        "Скуратова Софья",
        "Адаксин Тарас",
        "Касатый Раиса",
        "Уржумцева Оксана",
        "Ключникова Анастасия",
        "Рябцев Виссарион"
    ]
    
    var filteredUsers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 1 Информирует о любых тектовых изменениях
        searchController.searchResultsUpdater = self
        
        // 2 Скрывает вью для отображения другого контроллера с результатами
        // В нашем случае результаты отображает сам вьюконтроллер
        // Поэтому значение установлено false, чтобы не скрывать наш контроллер
        searchController.obscuresBackgroundDuringPresentation = false
        
        // 3 Здесь мы устанавливаем плейсхолдер текстфилду
        searchController.searchBar.placeholder = "Search Users"
        
        // 4 New for iOS 11, you add the searchBar to the navigationItem. This is necessary because Interface Builder is not yet compatible with UISearchController.
        // 4 Новое в iOS 11 мы добавляем searchBar в панельНавигации. Этого еще нет в сторибордах
        navigationItem.searchController = searchController
        
        // 5 Значение truе гарантирует, что панель поиска не останется на экране, если пользователь переходит к другому вьюКонтроллеру, пока активен UISearchController.
        definesPresentationContext = true
    }
    
    @IBAction func addFriend(_ sender: UIBarButtonItem) {
        addAndEditFirends(title: "Add", message: "Add new friend", placeholder: "Name") {
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filteredUsers.count
        }
          
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        
//        let candy: User
//        if isFiltering {
//          user = filteredUsers[indexPath.row]
//        } else {
//          user = users[indexPath.row]
//        }
//        cell.textLabel?.text = user.name
//        cell.detailTextLabel?.text = user.birth
//        return cell
        
        let user = users[indexPath.row]
        cell.nameLabel.text = user
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Build letters array:
        
        var letters: [Character]
        
        letters = users.map { (surname) -> Character in
            return surname[surname.startIndex]
        }
        
        letters = letters.sorted()
        
        letters = letters.reduce([], { (list, name) -> [Character] in
            if !list.contains(name) {
                return list + [name]
            }
            return list
        })
        return letters.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(
                                  forSectionIndexTitle: index
        )
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            users.remove(at: indexPath.row)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "detailFriendsTableViewSegue" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let friend = users[indexPath.row]
        let friendsDetailVC = segue.destination as! FriendsDetailCollectionViewController
        friendsDetailVC.navigationController?.title = friend
        friendsDetailVC.users.append(friend)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.indexPathForSelectedRow {
            performSegue(withIdentifier: "detailFriendsTableViewSegue", sender: nil)
        }
    }
}


extension FriendsTableViewController {
    func addAndEditFirends(title: String, message: String, placeholder: String, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        alert.addTextField { taskName in
            alertTextField = taskName
            alertTextField.layoutIfNeeded()
            alertTextField.autocorrectionType = .default
            alertTextField.autocapitalizationType = .sentences
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            self.users.append(newList)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.view.layoutIfNeeded()
        present(alert, animated: true)
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension FriendsTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // isSearchBarEmpty возвращает true, если текст, введенный в строке поиска, пуст; в противном случае возвращается false.
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Вычисляемое свойство, определяющее, фильтруете ли вы в настоящее время результаты или нет
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    
    // filterContentFor(_ searchText: String) фильтрует пользователей на основе searchText и помещает результаты в фильтр filteredUsers
    func filterContentFor(_ searchText: String) {
        filteredUsers = users.filter { users -> Bool in
            return users.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    // Теперь всякий раз, когда пользователь добавляет или удаляет текст в строке поиска, UISearchController будет информировать класс FriendsTableViewController об изменении посредством вызова updateSearchResults(for:), который, в свою очередь, вызывает filterContentFor(_ searchText:).
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentFor(searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.isUserInteractionEnabled = false
    }
}
