//
//  NotificationViewController.swift
//  ClubPlayNotificationContent
//
//  Created by Đức Anh on 7/10/26.
//

import UIKit
import UserNotifications
import UserNotificationsUI

final class NotificationViewController:
    UIViewController,
    UNNotificationContentExtension {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet private weak var venueLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        gameNameLabel.font = .preferredFont(forTextStyle: .title3)
        venueLabel.font = .preferredFont(forTextStyle: .subheadline)
        statusLabel.font = .preferredFont(forTextStyle: .subheadline)
    }

    func didReceive(
        _ notification: UNNotification
    ) {
        let content = notification.request.content
        let userInfo = content.userInfo

        titleLabel.text = content.title

        gameNameLabel.text =
            userInfo["gameName"] as? String
            ?? "ClubPlay Game"

        venueLabel.text =
            userInfo["venueName"] as? String
            ?? "Venue unavailable"

        statusLabel.text =
            userInfo["status"] as? String
            ?? "Updated"

        updateStatusAppearance()
    }

    private func updateStatusAppearance() {
        switch statusLabel.text?.lowercased() {
        case "confirmed":
            statusLabel.textColor = .systemGreen

        case "waitlisted":
            statusLabel.textColor = .systemOrange

        case "cancelled":
            statusLabel.textColor = .systemRed

        default:
            statusLabel.textColor = .systemBlue
        }
    }
}
