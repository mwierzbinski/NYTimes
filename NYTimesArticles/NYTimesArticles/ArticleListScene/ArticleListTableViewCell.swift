//
//  ArticleListTableViewCell.swift
//  NYTimesArticles
//
//  Created by Michal W on 12/02/2019.
//  Copyright © 2019 Michal W. All rights reserved.
//

import Foundation
import UIKit

final class ArticleListTableViewCell: UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var writtenBy: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
}
