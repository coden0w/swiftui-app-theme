// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// MARK: - AppTheme

/// A view wrapper that applies the user-selected app theme (Light, Dark, or System Default)
/// to its entire content subtree.
///
/// This struct reads and writes the current theme preference using `@AppStorage`,
/// persists the selection across app launches, and automatically applies the correct
/// `ColorScheme` via the `.preferredColorScheme(_:)` view modifier.
///
/// Use it as the root view of your app (or any sub-hierarchy) to enable theme support:
///
/// ```swift
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             AppTheme {
///                 ContentView()
///             }
///         }
///     }
/// }
/// ```
///
/// - Parameters:
///   - appThemeStyle: An optional initial theme. Defaults to `.systemDefault`.
///   - content: A view builder that provides the views to be themed.
public struct AppTheme<Content: View>: View {
    
    // MARK: - Properties
    
    /// The persisted theme style, stored in `UserDefaults` under the key "AppThemeStyle".
    /// Defaults to `.systemDefault` on first launch.
    @AppStorage("AppThemeStyle") private var appThemeStyle: AppThemeStyle = .systemDefault
    
    /// The child view hierarchy that will receive the selected color scheme.
    private let content: () -> Content
    
    // MARK: - Initializer
    
    /// Creates an `AppTheme` wrapper.
    ///
    /// - Parameters:
    ///   - appThemeStyle: The initial theme style to use before the persisted value is read.
    ///                    This value also becomes the default if no persisted value exists.
    ///                    Defaults to `.systemDefault`.
    ///   - content: A `@ViewBuilder` closure returning the views to be themed.
    public init(appThemeStyle: AppThemeStyle = .systemDefault,
                @ViewBuilder content: @escaping () -> Content) {
        // Override the default wrapped value of @AppStorage with the provided initial value
        self._appThemeStyle = AppStorage(wrappedValue: appThemeStyle, "AppThemeStyle")
        self.content = content
    }
    
    // MARK: - Body
    
    /// The view body applies the current `ColorScheme` (or `nil` for system default)
    /// to the entire content subtree.
    public var body: some View {
        content()
            .preferredColorScheme(appThemeStyle.colorScheme)
    }
}

// MARK: - AppThemeStyle

/// Represents the three possible theme modes supported by the app.
///
/// Values are persisted as raw strings, making them safe for `AppStorage`.
public enum AppThemeStyle: String, CaseIterable {
    /// Forces light mode regardless of system appearance.
    case light = "Light"
    
    /// Forces dark mode regardless of system appearance.
    case dark = "Dark"
    
    /// Follows the system's current appearance setting (the default).
    case systemDefault = "Default"
    
    /// Converts the enum case into the corresponding `ColorScheme` value expected by SwiftUI.
    ///
    /// - Returns: `.light` for `.light`, `.dark` for `.dark`, and `nil` for `.systemDefault`
    ///            (nil tells SwiftUI to respect the system's current setting).
    var colorScheme: ColorScheme? {
        switch self {
        case .light:          return .light
        case .dark:           return .dark
        case .systemDefault:  return nil
        }
    }
}
