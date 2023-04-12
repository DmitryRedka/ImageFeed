import UIKit

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var bearerToken: String? {
        get {
            return OAuth2TokenStorage().token
         }
    }
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let profile = profileService.profile else {
            return
        }

            addProfileImageView()
            addNameLabel(profile.username)
            addLoginNameLabel(profile.loginName)
            addDescriptionLabel(profile.bio)
            addLogoutButton()

        /*
        ProfileService.shared.fetchProfile(bearerToken!) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let profile):

                
                self.addProfileImageView()
                self.addNameLabel(profile.username)
                self.addLoginNameLabel(profile.loginName)
                self.addDescriptionLabel(profile.bio)
                self.addLogoutButton()
            case .failure:
                break
            }
        }
         */
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension ProfileViewController {
    func addProfileImageView() {
        let profileImage = UIImage(named: "avatar")
        profileImageView = UIImageView(image: profileImage)
        guard let profileImageView = profileImageView else {
            return
        }
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    
    func addNameLabel(_ text: String?) {
        nameLabel = UILabel()
        guard let nameLabel = nameLabel else {
            return
        }
        let text = text ?? "No name"
 
        nameLabel.text = text
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView!.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    
    private func addLoginNameLabel(_ text: String?) {
        loginNameLabel = UILabel()
        guard let loginNameLabel = loginNameLabel else {
            return
        }
        let text = text ?? "No login"
        loginNameLabel.text = text
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = .yPGray
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    
    private func addDescriptionLabel(_ text: String?) {
        descriptionLabel = UILabel()
        guard let descriptionLabel = descriptionLabel else {
            return
        }
        let text = text ?? "No description"
        descriptionLabel.text = text
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel!.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])

    }
    private func addLogoutButton() {
        let buttonImage = UIImage(named: "logout_button")
        
        let logoutButtonView = UIButton.systemButton(with: buttonImage!,
                                               target: nil,
                                               action: nil)
        logoutButtonView.tintColor = .yPRed
        logoutButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButtonView)
        NSLayoutConstraint.activate([
            logoutButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            logoutButtonView.centerYAnchor.constraint(equalTo: profileImageView!.centerYAnchor)
        ])

    }
}
