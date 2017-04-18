//
//  DropDownMenu.swift
//  SwiftSample
//
//  Created by Dave on 2017. 4. 17..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit

struct DPItem {
    
    var image: UIImage?
    var title: String
    
    init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
    }
    
    init(title: String) {
        self.title = title
    }
}

class DPDropDownMenu: UIView {
    
    @IBInspectable var text: String {
        get {
            return button.title(for: .normal) ?? ""
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    @IBInspectable var visibleItemCount: Int = 3
    
    @IBInspectable var headerTitle: String = "Header" {
        didSet {
            button.setTitle(headerTitle, for: .normal)
        }
    }
    
    @IBInspectable var headerTextColor: UIColor = .white {
        didSet {
            button.setTitleColor(headerTextColor, for: .normal)
        }
    }
    
    @IBInspectable var headerBackgroundColor: UIColor = .orange {
        didSet {
            button.backgroundColor = headerBackgroundColor
        }
    }
    
    @IBInspectable var contentTextColor: UIColor = .black {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable var contentBackgroundColor: UIColor = .white {
        didSet {
            if let table = tableView {
                table.backgroundColor = contentBackgroundColor
            }
        }
    }
    
    @IBInspectable var selectedContentTextColor: UIColor = .orange {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable var selectedContentBackgroundColor: UIColor = .white {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable var headerTextFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            button.titleLabel?.font = headerTextFont
        }
    }
    
    @IBInspectable var contentTextFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    var items = [DPItem]() {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    var selectedIndex = -1 {
        didSet {
            didSelectedItemIndex?(selectedIndex)
        }
    }
    
    var isFold = true {
        didSet {
            if isFold {
                fold()
            } else {
                unFold()
            }
        }
    }
    
    fileprivate var button: UIButton!
    fileprivate var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = bounds.size.height
            tableView.separatorInset = UIEdgeInsets.zero
        }
    }
    fileprivate var backgroundView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            backgroundView.addGestureRecognizer(tap)
        }
    }
    
    var didSelectedItemIndex: ((Int) -> (Void))?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        button = UIButton(type: .custom)
        button.frame = bounds
        button.addTarget(self, action: #selector(didSelectedButton(_:)), for: .touchUpInside)
        button.backgroundColor = headerBackgroundColor
        button.setTitleColor(headerTextColor, for: .normal)
        button.setTitle(headerTitle, for: .normal)
        button.titleLabel?.font = headerTextFont
        addSubview(button)
    }
    
    @objc private func didSelectedButton(_ sender: UIButton) {
        isFold = !isFold
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        isFold = true
    }
}

extension DPDropDownMenu {
    
    private var originTableFrame: CGRect {
        return CGRect(x: frame.origin.x, y: frame.origin.y + frame.size.height, width: frame.size.width, height: 0)
    }
    
    private var tableFrame: CGRect {
        if isFold {
            return originTableFrame
        } else {
            var frame = originTableFrame
            frame.size.height = itemHeight
            return frame
        }
    }
    
    private var itemHeight: CGFloat {
        if items.count > visibleItemCount {
            tableView.isScrollEnabled = true
            return CGFloat(visibleItemCount) * bounds.size.height
        } else {
            tableView.isScrollEnabled = false
            return CGFloat(items.count) * bounds.size.height
        }
    }
    
    var superSuperView: UIView {
        var v: UIView = self
        while (v.superview != nil) {
            v = v.superview!
        }
        return v
    }
    
    var duration: TimeInterval {
        return 0.25
    }
    
    fileprivate func fold() {
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.tableView.frame = self.tableFrame
        }) { [unowned self] finished in
            self.backgroundView.removeFromSuperview()
            self.tableView.removeFromSuperview()
        }
    }
    
    fileprivate func unFold() {
        backgroundView = UIView(frame: superSuperView.bounds)
        superSuperView.addSubview(backgroundView)
        
        tableView = UITableView(frame: originTableFrame, style: .plain)
        superSuperView.addSubview(tableView)
        tableView.reloadData()
        
        UIView.animate(withDuration: duration) { [unowned self] in
            self.tableView.frame = self.tableFrame
        }
    }
}

let dropDownCellIdentifier = "dropDownCellIdentifier"

extension DPDropDownMenu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: dropDownCellIdentifier) as? DPDropDownMenuCell
        if cell == nil {
            cell = DPDropDownMenuCell(style: .default, reuseIdentifier: dropDownCellIdentifier)
            cell?.backgroundColor = .clear
        }
        
        cell?.reload(item: items[indexPath.row])
        reload(cell: cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        isFold = true
        
        selectedIndex = indexPath.row
    }
    
    private func reload(cell: DPDropDownMenuCell, indexPath: IndexPath) {
        cell.textLabel?.font = contentTextFont
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = selectedContentBackgroundColor
            cell.textLabel?.textColor = selectedContentTextColor
        } else  {
            cell.backgroundColor = contentBackgroundColor
            cell.textLabel?.textColor = contentTextColor
        }
    }
}


class DPDropDownMenuCell: UITableViewCell {
    
    func reload(item: DPItem) {
        textLabel?.text = item.title
        imageView?.image = item.image
        
        if let _ = item.image {
            textLabel?.textAlignment = .left
        } else {
            textLabel?.textAlignment = .center
        }
    }
}
