//
//  MineViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import Foundation

private struct UserSettingKes {
    static fileprivate let activeUser: String = "ACTIVE_USER"
    static fileprivate let activeToken: String = "ACTIVE_TOKEN"
    static fileprivate let Notifications: String = "ACTIVE_Notifi"
    static fileprivate let searHistory: String = "SEAR_HISTORY"
    static func allKeys() -> [String] {
        return [activeUser,activeToken,searHistory]
    }
}

class UserSetting {
    static let `default` = UserSetting()
    private let standard: UserDefaults
    private init() {
        standard = UserDefaults.standard
    }

    func reset() {
        for key in UserSettingKes.allKeys() {
            standard.set(nil, forKey: key)
        }
    }
    
    var activeUserNotifications: Bool? {
        set {
            do {
                if let notifi = newValue {
                    standard.setValue(notifi, forKey: UserSettingKes.Notifications)
                } else {
                    standard.setValue(nil, forKey: UserSettingKes.Notifications)
                }
                standard.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        get {
            guard let notifi = standard.value(forKey: UserSettingKes.Notifications) as? Bool else {
                return nil
            }
            
            do {
                return notifi
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    var activeUserToken: String? {
        set {
            do {
                if let token = newValue {
                    standard.setValue(token, forKey: UserSettingKes.activeToken)
                } else {
                    standard.setValue(nil, forKey: UserSettingKes.activeToken)
                }
                standard.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        get {
            guard let token = standard.value(forKey: UserSettingKes.activeToken) as? String else {
                return nil
            }
            
            do {
                return token
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }

    var searchHistory: [String]? {
        set {
            do {
                if let token = newValue {
                    standard.setValue(token, forKey: UserSettingKes.searHistory)
                } else {
                    standard.setValue(nil, forKey: UserSettingKes.searHistory)
                }
                standard.synchronize()
            } catch {
                print(error.localizedDescription)
            }
        }

        get {
            guard let token = standard.value(forKey: UserSettingKes.searHistory) as? [String] else {
                return nil
            }

            do {
                return token
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }

//
//    var activeUserData: User? {
//        set {
//            do {
//                if let user = newValue {
//                    let data = try JSONEncoder().encode(user)
//                    standard.setValue(data, forKey: UserSettingKes.activeUser)
//                } else {
//                    standard.setValue(nil, forKey: UserSettingKes.activeUser)
//                }
//                standard.synchronize()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//
//        get {
//            guard let data = standard.value(forKey: UserSettingKes.activeUser) as? Data else {
//                return nil
//            }
//
//            do {
//                return try JSONDecoder().decode(User.self, from: data)
//            } catch {
//                print(error.localizedDescription)
//                return nil
//            }
//        }
//    }
}
