//
//  ScrollTableViewController.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import UIKit
import os.signpost

final class ScrollTableViewController: UITableViewController {
    private lazy var scrollOSLog = OSLog(subsystem: scrollLog.subsystem, category: scrollLog.category)
    private lazy var navTransitionOSLog = OSLog(subsystem: navTransitionLog.subsystem, category: navTransitionLog.category)
    
    private lazy var dataSource = ((1...10).flatMap{ _ -> [String] in emojiItems })
    let emojiItems = [
        "😎  Cool",
        "♥️  Heart",
        "☹️  Sad",
        "😊  Smile",
        "🤔  Thinking",
        "😍  Love",
        "🤗  Hug",
        "🥳  Party",
        "😕  Confused",
        "👍  PlusOne",
        "👎  MinusOne",
        "🥱  Yawn",
        "🤝  HandShake",
        "🙏  Pray",
        "✌️  Victory",
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
}

// MARK: Signpost Events
extension ScrollTableViewController {
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if #available(iOS 14.0, *) {
            os_signpost(.animationBegin, log: scrollOSLog, name: SignpostName.scrollDecelerationSignpost)
        } else {
            os_signpost(.begin, log: scrollOSLog, name: SignpostName.scrollDecelerationSignpost)
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        os_signpost(.end, log: scrollOSLog, name: SignpostName.scrollDecelerationSignpost)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if #available(iOS 14.0, *) {
            os_signpost(.animationBegin, log: scrollOSLog, name: SignpostName.scrollDraggingSignpost)
        } else {
            os_signpost(.begin, log: scrollOSLog, name: SignpostName.scrollDraggingSignpost)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        os_signpost(.end, log: scrollOSLog, name: SignpostName.scrollDraggingSignpost)
    }
    
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 14.0, *) {
            os_signpost(.animationBegin, log: navTransitionOSLog, name: SignpostName.scrollViewNavTransition)
        } else {
            os_signpost(.begin, log: navTransitionOSLog, name: SignpostName.scrollViewNavTransition)
        }
    }
    
    override func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        os_signpost(.end, log: navTransitionOSLog, name: SignpostName.scrollViewNavTransition)
    }
}

