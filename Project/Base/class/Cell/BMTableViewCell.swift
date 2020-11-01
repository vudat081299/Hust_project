//
//  BMTableViewCell.swift
//  Project
//
//  Created by Be More on 11/1/20.
//

import UIKit

class BMTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    /// get the table view own the cell.
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }

    /// get the index path of the given cell.
    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
    
    // MARK: - Lifecycles.

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    // MARK: - Helpers.
    
    private static func identifier() -> String {
        return String(describing: self.self)
    }
    
    func setUpViews() {
        self.selectionStyle = .none
    }
    
    static func registerCellByClass(_ tableView: UITableView) {
        tableView.register(self.self, forCellReuseIdentifier: self.identifier())
    }

    static func registerCellByNib(_ tableView: UITableView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: self.identifier())
    }

    static func loadCell(_ tableView: UITableView) -> BMTableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: self.identifier()) as? BMTableViewCell) else {
            return BMTableViewCell()
        }
        return cell
    }

    static func loadCell(_ tableView: UITableView, indexPath: IndexPath) -> BMTableViewCell {
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: self.identifier(), for: indexPath) as? BMTableViewCell) else {
            return BMTableViewCell()
        }
        return cell
    }
    
}
