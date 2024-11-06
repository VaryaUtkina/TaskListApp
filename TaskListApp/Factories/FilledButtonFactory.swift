//
//  FilledButtonFactory.swift
//  TaskListApp
//
//  Created by Варвара Уткина on 06.11.2024.
//

import UIKit

/// Protocol that defines an interface for creating buttons.
protocol ButtonFactory {
    /// Create a button.
    ///
    /// - Returns: A `UIButton` instance.
    func createButton() -> UIButton
}

/// Custom implementation of the `ButtonFactory` protocol.
final class FilledButtonFactory: ButtonFactory {
    /// The title of the button.
    let title: String
    
    /// The background color of the button.
    let color: UIColor
    
    /// The action to be performed when the button is tapped.
    let action: UIAction
    
    /// Initializes a new custom button factory with the provided title, color and action.
    ///
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - color: The background color of the button.
    ///   - action: The action to be performed when the button is tapped.
    init(title: String, color: UIColor, action: UIAction) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    /// Creates a button with the predefined title, color and action.
    ///
    /// - Returns: A `UIButton` instance with the predefined attributes.
    func createButton() -> UIButton {
        <#code#>
    }
}
