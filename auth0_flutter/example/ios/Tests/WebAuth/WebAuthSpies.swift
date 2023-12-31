import Combine
import Flutter
import Auth0

@testable import auth0_flutter

// MARK: - MethodHandler Spies

class SpyMethodHandler: MethodHandler {
    private(set) var argumentsValue: [String: Any] = [:]

    func handle(with arguments: [String: Any], callback: @escaping FlutterResult) {
        self.argumentsValue = arguments
        callback(nil)
    }
}

// MARK: - Auth0.swift Spies

class SpyWebAuth: WebAuth {
    let clientId = ""
    let url = mockURL
    var telemetry = Telemetry()
    var logger: Logger?

    var loginResult: WebAuthResult = .success(Credentials())
    var logoutResult: WebAuthResult = .success(())
    var calledLogin = false
    var calledLogout = false

    private(set) var scopeValue: String?
    private(set) var parametersValue: [String: String]?
    private(set) var redirectURLValue: URL?
    private(set) var audienceValue: String?
    private(set) var issuerValue: String?
    private(set) var leewayValue: Int?
    private(set) var maxAgeValue: Int?
    private(set) var useEmphemeralSessionValue: Bool?
    private(set) var invitationURLValue: URL?
    private(set) var organizationValue: String?
    private(set) var provider: WebAuthProvider?

    init() {}

    func connection(_ connection: String) -> Self {
        return self
    }

    func scope(_ scope: String) -> Self {
        self.scopeValue = scope
        return self
    }

    func connectionScope(_ connectionScope: String) -> Self {
        return self
    }

    func state(_ state: String) -> Self {
        return self
    }

    func parameters(_ parameters: [String: String]) -> Self {
        self.parametersValue = parameters
        return self
    }

    func redirectURL(_ redirectURL: URL) -> Self {
        self.redirectURLValue = redirectURL
        return self
    }

    func audience(_ audience: String) -> Self {
        self.audienceValue = audience
        return self
    }

    func nonce(_ nonce: String) -> Self {
        return self
    }

    func issuer(_ issuer: String) -> Self {
        self.issuerValue = issuer
        return self
    }

    func leeway(_ leeway: Int) -> Self {
        self.leewayValue = leeway
        return self
    }

    func maxAge(_ maxAge: Int) -> Self {
        self.maxAgeValue = maxAge
        return self
    }

    func useEphemeralSession() -> Self {
        self.useEmphemeralSessionValue = true
        return self
    }

    func invitationURL(_ invitationURL: URL) -> Self {
        self.invitationURLValue = invitationURL
        return self
    }

    func organization(_ organization: String) -> Self {
        self.organizationValue = organization
        return self
    }

    func provider(_ provider: @escaping WebAuthProvider) -> Self {
        self.provider = provider
        return self
    }

    func start(_ callback: @escaping (WebAuthResult<Credentials>) -> Void) {
        calledLogin = true
        callback(loginResult)
    }

#if compiler(>=5.5) && canImport(_Concurrency)
#if compiler(>=5.5.2)
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.2, *)
    func start() async throws -> Credentials {
        return try loginResult.get()
    }
#else
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func start() async throws -> Credentials {
        return try loginResult.get()
    }
#endif
#endif

    @available(iOS 13.0, *)
    func start() -> AnyPublisher<Credentials, WebAuthError> {
        return loginResult.publisher.eraseToAnyPublisher()
    }

    func clearSession(federated: Bool, callback: @escaping (WebAuthResult<Void>) -> Void) {
        calledLogout = true
        callback(logoutResult)
    }
}

class MockWebAuthUserAgent: WebAuthUserAgent {
    func start() {
    }
    
    func finish(with result: Auth0.WebAuthResult<Void>) {
    }
}


class SpySafariProvider {
    var presentationStyle: UIModalPresentationStyle? = nil
    
    init() {}
    
    func provider(_ style: UIModalPresentationStyle) -> WebAuthProvider {
        self.presentationStyle = style
        
        return { (_: URL, _: @escaping (WebAuthResult<Void>) -> Void) -> (WebAuthUserAgent) in
            return MockWebAuthUserAgent()
        }
    }
}
