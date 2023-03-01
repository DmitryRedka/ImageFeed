import UIKit

class SplashViewController: UIViewController {
    
    private let showAuthentificationScreenSegueIdentification = "showAuthentificationScreen"
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage().token {
            switchTapBarController()
        } else {
            performSegue(withIdentifier: showAuthentificationScreenSegueIdentification, sender: nil)
        }
    }
    
    private func switchTapBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid to switch TapBarController")
        }
        let tapBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tapBarController
    }
}
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthentificationScreenSegueIdentification {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError(("Failed to prepare \(showAuthentificationScreenSegueIdentification)"))
            }
            viewController.delegate = self
        } else {
            prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegateProtocol {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchAuthToken(didAuthenticateWithCode: code) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                self.switchTapBarController()
            case .failure:
                break
            }
        }
    }
}
