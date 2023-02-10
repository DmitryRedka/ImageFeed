import UIKit

final class ProfileViewController: UIViewController {
    /*
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    @IBOutlet private var logoutButton: UIButton!

    @IBAction private func didTapLogoutButton() {
    }
    */
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileImageView()
        addNameLabel()
        addLoginNameLabel()
        addDescriptionLabel()
        addLogoutButton()
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
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    func addNameLabel() {
        nameLabel = UILabel()
        guard let nameLabel = nameLabel else {
            return
        }
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profileImageView!.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    func addLoginNameLabel() {
        loginNameLabel = UILabel()
        guard let loginNameLabel = loginNameLabel else {
            return
        }
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = .YPGray
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    func addDescriptionLabel() {
        descriptionLabel = UILabel()
        guard let descriptionLabel = descriptionLabel else {
            return
        }
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel!.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    func addLogoutButton() {
        let buttonImage = UIImage(named: "logout_button")
        
        let logoutButtonView = UIButton.systemButton(with: buttonImage!,
                                               target: nil,
                                               action: nil)
        logoutButtonView.tintColor = .YPRed
        logoutButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButtonView)
        logoutButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        logoutButtonView.centerYAnchor.constraint(equalTo: profileImageView!.centerYAnchor).isActive = true
    }
}
