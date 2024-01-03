//
//  IdentityVerificationViewModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 04.10.23.
//

import Foundation
import IdensicMobileSDK


class IdentityVerificationViewModel: ObservableObject {
    @Published private var sdk: SNSMobileSDK!
    
    var manager: VerifyIdentityProtocol
    
    init(manager: VerifyIdentityProtocol = VerifyIdentityService.shared) {
        self.manager = manager
    }

    
    func initializeSDK() {
        let accessToken = "YOUR_ACCESS_TOKEN"
        // Create an instance of the SDK
        let sdk = SNSMobileSDK(accessToken: accessToken)
        
        // Check if the SDK setup was successful
        guard sdk.isReady else {
            print("Initialization failed: " + sdk.verboseStatus)
            return
        }
        
        print("sdk is ready")
        
        sdk.tokenExpirationHandler { (onComplete) in
            // Call your backend to get a new token
            // Replace get_token_from_your_backend with your actual token retrieval logic
            self.get_token_from_your_backend { (newToken) in
                onComplete(newToken)
            }
        }
        
        self.addEvents(sdk: sdk)
        self.setupTheme(sdk: sdk)
        self.sdk = sdk
        self.sdk.present()
    }
    
    func addEvents(sdk: SNSMobileSDK) {
        sdk.onStatusDidChange { (sdk, prevStatus) in
            
            print("onStatusDidChange: [\(sdk.description(for: prevStatus))] -> [\(sdk.description(for: sdk.status))]", terminator: " ")
            
            // dismiss if status changes from initial to pending or incomplete to pending

            switch sdk.status {
                
                
            case .ready:
                // Technically .ready couldn't ever be passed here, since the callback has been set after `status` became .ready
                break

            case .failed:
                print("failReason: [\(sdk.description(for: sdk.failReason))] - \(sdk.verboseStatus)")
                
            case .initial:
                print("No verification steps are passed yet")
                
            case .incomplete:
                print("Some but not all of the verification steps have been passed over")
                
            case .pending:
                if prevStatus == .initial || prevStatus == .incomplete {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        sdk.dismiss()
                    }
                }
                print("Verification is pending")
                
            case .temporarilyDeclined:
                print("Applicant has been declined temporarily")
                
            case .finallyRejected:
                print("Applicant has been finally rejected")
                
            case .approved:
                print("Applicant has been approved")
                
            case .actionCompleted:
                print("Applicant action has been completed")
            }
        }
        
        // MARK: onEvent
        //
        // Subscribing to `onEvent` allows you to be aware of the events happening along the processing
        //
        sdk.onEvent { (sdk, event) in
            
            switch event.eventType {
            
            case .applicantLoaded:
                if let event = event as? SNSEventApplicantLoaded {
                    print("onEvent: Applicant [\(event.applicantId)] has been loaded")
                }

            case .stepInitiated:
                if let event = event as? SNSEventStepInitiated {
                    print("onEvent: Step [\(event.idDocSetType)] has been initiated")
                }
                
            case .stepCompleted:
                if let event = event as? SNSEventStepCompleted {
                    print("onEvent: Step [\(event.idDocSetType)] has been \(event.isCancelled ? "cancelled" : "fulfilled")")
                }
                
            case .analytics:
                if let event = event as? SNSEventAnalytics {
                    print("onEvent: Analytics event [\(event.eventName)] has occured with payload=\(event.eventPayload ?? [:])")
                }

            @unknown default:
                print("onEvent: eventType=[\(event.description(for: event.eventType))] payload=\(event.payload)")
            }

        }

        // MARK: onDidDismiss
        //
        // A way to be notified when `mainVC` is dismissed
        //
        sdk.onDidDismiss { (sdk) in
            print("onDidDismiss: sdk has been dismissed with status [\(sdk.description(for: sdk.status))]")
        }
    }
    
    func setupTheme(sdk: SNSMobileSDK) {
        sdk.theme.colors.contentStrong = .init(AppColors.darkBlue)
        sdk.theme.colors.primaryButtonBackground = .init(AppColors.green)
        sdk.theme.colors.primaryButtonBackgroundHighlighted  = .init(AppColors.green.opacity(0.5))
    }
    
    func get_token_from_your_backend(completion: @escaping (String?) -> Void) {
        manager.getAccessToken { token in
            if let token {
                completion(token.token)
            }
        }
    }
}
