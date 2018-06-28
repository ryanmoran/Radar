import Foundation

protocol Defaults {
  func register(defaults registrationDictionary: [String: Any])
  func array(forKey defaultName: String) -> [Any]?
  func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: Defaults {}
