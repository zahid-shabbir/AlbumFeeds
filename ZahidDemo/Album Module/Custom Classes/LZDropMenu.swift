//
//  LZDropMenu.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
//
    import Foundation
import UIKit
protocol dropDownDelegate: AnyObject {
    func dropDownPressed(string: String, sortyBy: AlbumSortState)
}
enum AlbumSortState: String {
    case ascending = "Ascending"
    case descending = "Descending"
}
    class DropDownBtn: UIButton, dropDownDelegate {
    func dropDownPressed(string: String, sortyBy: AlbumSortState) {
        self.dismissDropDown()
    }
    var dropView = DropDownView()
    var height = NSLayoutConstraint()
    override init(frame: CGRect) {
        super.init(frame: frame)
            self.backgroundColor = UIColor.darkGray
            dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.layer.shadowPath = UIBezierPath(rect: dropView.bounds).cgPath
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        dropView.zround(radius: 10)
    }
    override func didMoveToSuperview() {
        if self.superview != nil {
            // the view was added as a subview to superview
            self.superview?.addSubview(dropView)
            self.superview?.bringSubviewToFront(dropView)
            dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            height = dropView.heightAnchor.constraint(equalToConstant: 0)
        } else {
            // the view was removed from its superview
        }
    }
    public func showDropDownMenu() {
        if isOpen == false {
                    isOpen = true
                    NSLayoutConstraint.deactivate([self.height])
                    if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
                            NSLayoutConstraint.activate([self.height])
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
                } else {
            isOpen = false
                    NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
                }
    }
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
                    isOpen = true
                    NSLayoutConstraint.deactivate([self.height])
                    if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
                            NSLayoutConstraint.activate([self.height])
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
                } else {
            isOpen = false
                    NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
                }
    }
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    var dropDownOptions = ["Descending", "Ascending"]
    var tableView = UITableView()
    weak var delegate: dropDownDelegate!
    override init(frame: CGRect) {
        super.init(frame: frame)
            tableView.backgroundColor = UIColor.systemYellow
        self.backgroundColor = UIColor.systemYellow
                tableView.delegate = self
        tableView.dataSource = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(tableView)
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.zround(radius: 12)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
            cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = UIColor.systemYellow
        cell.textLabel?.textColor = .label
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row], sortyBy: AlbumSortState(rawValue: dropDownOptions[indexPath.row]) ?? .ascending)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
