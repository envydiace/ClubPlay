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

        venueLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 0
    }

    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        let userInfo = content.userInfo

        titleLabel.text = content.title

        gameNameLabel.text =
            userInfo["gameName"] as? String ?? "ClubPlay Game"

        var changes: [String] = []

        // MARK: - Venue change

        if
            let oldVenue =
                userInfo["previousVenueName"] as? String,
            let newVenue =
                userInfo["updatedVenueName"] as? String
        {
            venueLabel.text = newVenue

            changes.append(
                """
                Venue changed
                \(oldVenue) → \(newVenue)
                """
            )
        } else {
            venueLabel.text = nil
        }

        // MARK: - Kick-off change

        if
            let previousTimestamp =
                userInfo["previousKickOffAt"] as? TimeInterval,
            let updatedTimestamp =
                userInfo["updatedKickOffAt"] as? TimeInterval
        {
            let previousDate =
                Date(timeIntervalSince1970: previousTimestamp)

            let updatedDate =
                Date(timeIntervalSince1970: updatedTimestamp)

            changes.append(
                """
                Kick-off changed
                \(format(previousDate)) → \(format(updatedDate))
                """
            )
        }

        statusLabel.text =
            changes.isEmpty
            ? "Game details updated"
            : changes.joined(separator: "\n\n")
    }

    private func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, h:mm a"
        return formatter.string(from: date)
    }
}
