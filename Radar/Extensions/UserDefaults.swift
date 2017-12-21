import Foundation

protocol Defaults {
  func register(defaults registrationDictionary: [String: Any])
  func array(forKey defaultName: String) -> [Any]?
}

extension UserDefaults: Defaults {}
