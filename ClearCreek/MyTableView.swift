//
//  MyTableView.swift
//  ShaadeePK
//
//  Created by Ali Sher on 30/10/2022.
//

import Foundation
import UIKit

class myTableView: UITableView {
   

  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet{
      self.invalidateIntrinsicContentSize()
    }
  }

  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
  }
}
