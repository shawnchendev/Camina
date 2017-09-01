//
//  userProfileViewController.swift
//  EastCoastTrail
//
//  Created by Shawn Chen on 2017-06-07.
//  Copyright © 2017 Shawn Chen. All rights reserved.
//

import UIKit
import Firebase
import MapboxStatic


class userProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    var user : defaultUser?
    var userSessions = [userSession]()
    var totalTime = 0
    var totalSession = 0
    var totalDistance = 0.0
    var totalSteps = 0
    
    let mapPreviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        cv.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        cv.isPagingEnabled = true
        return cv
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var profileCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CapeSpearNight")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.minimumScaleFactor = 10/UIFont.labelFontSize
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let titleString = ["Sessions:", "Distance:", "Time:", "Steps:"]
    let subtitleString = ["Completed", "Meter", "Minues", "Total"]
    let iconImage = [UIImage(named: "approval"), UIImage(named: "distance"), UIImage(named: "time"), UIImage(named: "step")]
    
    
     let cellId = "cellId"


      let accessToken = "pk.eyJ1IjoibWMyODgyIiwiYSI6ImNqMjZjZjdsMDAwZTEzNHFmNXk1bGJpbDIifQ.jaXEzY40GjNuZSr6PVG9Tg"


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! overviewCell
        
        cell.titleLabel.text = titleString[indexPath.item]
        cell.subtitleLabel.text = subtitleString[indexPath.item]
        cell.iconImageView.image = iconImage[indexPath.item]
        cell.numberLabel.text = numberString[indexPath.item]
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 4 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
   
    
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var numberString = ["0","0","0","0"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
        fetchUserSessionID {
            
            self.numberString = [String(self.totalSession),String(self.totalDistance ), String(self.totalTime / 60 ), String(self.totalSteps)]
            
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
                
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex:"ECF0F1")
        setupNavigationController()
        
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(overviewCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(profileCoverImageView)
        view.addSubview(collectionView)

        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        setupProfileImageView()
        setupProfileCoverImageView()

        setupCollectionView()
        
    }
    
    func setupNavigationController(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Setting"), style: .plain, target: self, action: #selector(signOutAlert))
        self.navigationItem.rightBarButtonItem?.tintColor = .white

    }
    
    
    
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileCoverImageView.bottomAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: profileCoverImageView.bottomAnchor, constant: -4).isActive = true
    }
    
    func setupProfileCoverImageView() {
        //need x, y, width, height constraints
        profileCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileCoverImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileCoverImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        profileCoverImageView.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    func setupCollectionView(){
      
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: profileCoverImageView.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo:view.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    
    func fetchMapSanpshot(path:[CLLocationCoordinate2D])->UIImage{

        let camera = SnapshotCamera(lookingAtCenter: path.first!, zoomLevel: 13)
        let options = SnapshotOptions(styleURL: URL(string: "mapbox://styles/mapbox/streets-v10")!, camera: camera, size: CGSize(width: 200, height: 200))
        let snapshot = Snapshot(options: options, accessToken:accessToken)
        let route = Path(coordinates: path)
        route.strokeWidth = 2
    
        route.strokeColor = .black
        #if os(macOS)
            route.fillColor = NSColor.red.withAlphaComponent(0.25)
        #else
            route.fillColor = UIColor.clear
        #endif
        options.overlays = [route]
        return snapshot.image!
    }
    
    func getPathFromSession(session: userSession)-> [CLLocationCoordinate2D]{
        var path = [CLLocationCoordinate2D]()
        
        for c in session.path{
            let p = c as! [String:AnyObject]
            let coordinate = CLLocationCoordinate2D(latitude: p["lat"] as! CLLocationDegrees, longitude: p["long"] as! CLLocationDegrees)
            path.append(coordinate)
        }
        
        return path
    }

    
    func handleLogOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError{
            print(logoutError)
        }
        self.presentRootView()
    }
    
    
    
    
    func fetchUserSessionID(_ completion: @escaping  () -> Void ){
        var userSessionID = [String]()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("userSession").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for i in dictionary{
                    let id = i.value as? [String: AnyObject]
                    userSessionID.append(id?["SessionID"] as! String)
                }
            }
            self.totalSession = userSessionID.count
            self.userSessions = []
            self.totalTime = 0
            self.totalDistance = 0
            self.totalSteps = 0
            for i in userSessionID{
                FIRDatabase.database().reference().child("Session").child(i).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let session = userSession(dictionary: dictionary)
                        self.userSessions.append(session)
                        self.totalTime += dictionary["time"] as! Int
                        self.totalDistance += dictionary["distance"] as! Double
                        self.totalSteps += dictionary["steps"] as! Int
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                completion()
                }, withCancel: nil)
            }
          
        }, withCancel: nil)
        
        
    }
  
    

    

    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUserData(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = defaultUser(dictionary: dictionary)
                if user.profileImageURL != nil{
                    self.profileImageView.loadImageUsingCacheWithUrlString((user.profileImageURL)!)
                }
                self.userNameLabel.text = user.name
            }
            
        }, withCancel: nil)
    }
    
    func signOutAlert(){
        
        let refreshAlert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
//        
//        refreshAlert.addAction(UIAlertAction(title: "Edit Profile", style: .default, handler: { (action: UIAlertAction!) in
//            
//        }))
//    
//        refreshAlert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (action: UIAlertAction!) in
//            
//        }))
        refreshAlert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (action: UIAlertAction!) in
                self.handleLogOut()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
   }


class overviewCell: BaseCell{
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 10/UIFont.labelFontSize
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var subtitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        
        label.minimumScaleFactor = 0.1
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var numberLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 10/UIFont.labelFontSize
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let separateView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "00B16A")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "approval")
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(numberLabel)
        addSubview(separateView)
        
        
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        iconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        iconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 8).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5).isActive = true
        
        subtitleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 14).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        
        numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        separateView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separateView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separateView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separateView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        

}


}


