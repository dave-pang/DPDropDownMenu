//
//  DropDownMenu.swift
//  SwiftSample
//
//  Created by Dave on 2017. 4. 17..
//  Copyright © 2017년 Yainoma. All rights reserved.
//

import UIKit

public struct DPItem {
    
    public var image: UIImage?
    public var title: String
    
    public init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
    }
    
    public init(title: String) {
        self.title = title
    }
}

public class DPDropDownMenu: UIView {
    
    @IBInspectable public var visibleItemCount: Int = 3
    
    @IBInspectable public var headerTitle: String = "Header" {
        didSet {
            button.setTitle(headerTitle, for: .normal)
        }
    }
    
    @IBInspectable public var headerTextColor: UIColor = .white {
        didSet {
            button.setTitleColor(headerTextColor, for: .normal)
        }
    }
    
    @IBInspectable public var headerBackgroundColor: UIColor = .orange {
        didSet {
            button.backgroundColor = headerBackgroundColor
        }
    }
    
    @IBInspectable public var menuTextColor: UIColor = .black {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable public var menuBackgroundColor: UIColor = .white {
        didSet {
            if let table = tableView {
                table.backgroundColor = menuBackgroundColor
            }
        }
    }
    
    @IBInspectable public var selectedMenuTextColor: UIColor = .orange {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable public var selectedMenuBackgroundColor: UIColor = .white {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable public var headerTextFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            button.titleLabel?.font = headerTextFont
        }
    }
    
    @IBInspectable public var menuTextFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    public var items = [DPItem]() {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    public var selectedIndex = -1 {
        didSet {
            didSelectedItemIndex?(selectedIndex)
        }
    }
    
    fileprivate var isFold = true {
        didSet {
            if isFold {
                fold()
            } else {
                unFold()
            }
        }
    }
    
    fileprivate var button: UIButton! {
        didSet {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didSelectedButton(_:)), for: .touchUpInside)
            button.backgroundColor = headerBackgroundColor
            button.setTitleColor(headerTextColor, for: .normal)
            button.setTitle(headerTitle, for: .normal)
            button.titleLabel?.font = headerTextFont
        }
    }
    
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
    
    public var didSelectedItemIndex: ((Int) -> (Void))?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    public convenience init(items: [DPItem]) {
        self.init(frame: .zero)
        
        self.items = items
    }
    
    private func setup() {
        button = UIButton(type: .custom)
        addSubview(button)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[b]|", options: [], metrics: [:], views: ["b": button]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[b]|", options: [], metrics: [:], views: ["b": button]))
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
    
    private var superSuperView: UIView {
        var v: UIView = self
        while (v.superview != nil) {
            v = v.superview!
        }
        return v
    }
    
    private var duration: TimeInterval {
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

fileprivate let dropDownCellIdentifier = "dropDownCellIdentifier"

extension DPDropDownMenu: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: dropDownCellIdentifier) as? DPDropDownMenuCell
        if cell == nil {
            cell = DPDropDownMenuCell(style: .default, reuseIdentifier: dropDownCellIdentifier)
            cell?.backgroundColor = .clear
        }
        
        cell?.reload(item: items[indexPath.row])
        reload(cell: cell!, indexPath: indexPath)
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        isFold = true
        
        selectedIndex = indexPath.row
    }
    
    private func reload(cell: DPDropDownMenuCell, indexPath: IndexPath) {
        cell.textLabel?.font = menuTextFont
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = selectedMenuBackgroundColor
            cell.textLabel?.textColor = selectedMenuTextColor
        } else  {
            cell.backgroundColor = menuBackgroundColor
            cell.textLabel?.textColor = menuTextColor
        }
    }
}


class DPDropDownMenuCell: UITableViewCell {
    
    public func reload(item: DPItem) {
        textLabel?.text = item.title
        imageView?.image = item.image
        
        if let _ = item.image {
            textLabel?.textAlignment = .left
        } else {
            textLabel?.textAlignment = .center
        }
    }
}
