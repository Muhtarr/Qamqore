import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    let inputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
        
    }()
    
    lazy var logRegButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentCotrol.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = PassTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = PassTextField.text, let name = nameTextField.text, let number = numberTextField.text
            else {
                print("Form is not valid")
                return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
//            successfully auth user
            let ref = Database.database().reference(fromURL: "https://school-project-8ca50.firebaseio.com/")
            let usersReferences = ref.child("users").child(uid)
            let values = ["name" : name, "email" : email, "number" : number]
            usersReferences.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                
                print("Successfully save DB")
                
            })
        })
        
    }
    
    
    let nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let nameSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let PassTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
        
    }()
    
    
    let numberTextField: UITextField = {
        let number = UITextField()
        number.placeholder = "Number"
        number.translatesAutoresizingMaskIntoConstraints = false
        return number
    }()
    
    let numberSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var loginRegisterSegmentCotrol: UISegmentedControl = {
        let sc = UISegmentedControl(items:["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegmentCotrol.titleForSegment(at: loginRegisterSegmentCotrol.selectedSegmentIndex)
        logRegButton.setTitle(title, for: .normal)
        
//        change Login Reg данные заполняющие поля
        inputsContainerViewHeighAnchor?.constant = loginRegisterSegmentCotrol.selectedSegmentIndex == 0 ? 100 : 200
//        change Name убираем Name из поля
        nameTextFieldHeighAnchor?.isActive = false
        nameTextFieldHeighAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentCotrol.selectedSegmentIndex == 0 ? 0 : 1/4)
        nameTextFieldHeighAnchor?.isActive = true
        
        emailTextFieldHeighAnchor?.isActive = false
        emailTextFieldHeighAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentCotrol.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        emailTextFieldHeighAnchor?.isActive = true
        
        passwordTextFieldHeighAnchor?.isActive = false
        passwordTextFieldHeighAnchor = PassTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentCotrol.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeighAnchor?.isActive = true
        
        numberTextFieldHeighAnchor?.isActive = false
        numberTextFieldHeighAnchor = numberTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentCotrol.selectedSegmentIndex == 0 ? 0 : 1/4)
        numberTextFieldHeighAnchor?.isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 31, g: 45, b: 150)
        
        //instantiating the input viewer
        view.addSubview(inputContainerView)
        view.addSubview(logRegButton)
        view.addSubview(numberTextField)
        view.addSubview(loginRegisterSegmentCotrol)
        
        
        
        setupInputContainerView()
        setupLogRegButton()
        setupLoginRegisterSegmentedControl()
        
    }
    
    func setupLoginRegisterSegmentedControl(){
//        need x y , width heigh
        loginRegisterSegmentCotrol.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentCotrol.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentCotrol.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentCotrol.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupLogRegButton(){
        
        //Constraints :  need x,y, width and height
        logRegButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logRegButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        
        //how wide
        logRegButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        logRegButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    var inputsContainerViewHeighAnchor: NSLayoutConstraint?
    var nameTextFieldHeighAnchor: NSLayoutConstraint?
    var emailTextFieldHeighAnchor: NSLayoutConstraint?
    var numberTextFieldHeighAnchor: NSLayoutConstraint?
    var passwordTextFieldHeighAnchor: NSLayoutConstraint?
    
    
    
    func setupInputContainerView() {
        
        //Constraints :  need x,y, width and height
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeighAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 200)
            inputsContainerViewHeighAnchor?.isActive = true
        
        
        
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparator)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparator)
        inputContainerView.addSubview(numberTextField)
        inputContainerView.addSubview(numberSeparator)
        inputContainerView.addSubview(PassTextField)
        
        
        //Constraints :  need x,y, width and height
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeighAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4)
        nameTextFieldHeighAnchor?.isActive = true
        
        
        //Constraints :  need x,y, width and height
        nameSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //Constraints :  need x,y, width and height
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeighAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4)
        emailTextFieldHeighAnchor?.isActive = true
        
        //Constraints :  need x,y, width and height
        emailSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        //Constraints :  need x,y, width and height
        PassTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        PassTextField.topAnchor.constraint(equalTo: numberTextField.bottomAnchor).isActive = true
        PassTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHeighAnchor = PassTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeighAnchor?.isActive = true
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //Constraints :  need x,y, width and height
        numberTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        numberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        numberTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        numberTextFieldHeighAnchor = numberTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4)
        numberTextFieldHeighAnchor?.isActive = true
        
        numberSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        numberSeparator.topAnchor.constraint(equalTo: numberTextField.bottomAnchor).isActive = true
        numberSeparator.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        numberSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
