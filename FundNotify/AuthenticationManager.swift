//
//  AuthenticationManager.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/18.
//

import Foundation
import LocalAuthentication

class AuthenticationManager {
    static func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to continue."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authenticationError?.localizedDescription)
                    }
                }
            }
        } else {
            completion(false, error?.localizedDescription)
        }
    }
}
