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
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
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
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        return lbl
    }()
    
    let statView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let overviewLabel : UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.textColor = UIColor(hex: "00B16A")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Distance: "
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let sessionLabel : UILabel = {
        let label = UILabel()
        label.text = "Completed Session: "
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Time: "
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let stepsLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Steps: "
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    let travelDistance : UILabel = {
        let label = UILabel()
        label.text = "0 m"
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let travelTime : UILabel = {
        let label = UILabel()
        label.text = "0 mins"
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let nSteps : UILabel = {
        let label = UILabel()
        label.text = "0 steps"
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let nSession : UILabel = {
        let label = UILabel()
        label.text = "0 "
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let separateView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "00B16A")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let completedLogLabel : UILabel = {
        let label = UILabel()
        label.text = "Completed Log"
        label.textColor = UIColor(hex: "00B16A")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var scrollView: UIScrollView!

    
     let sessionCellId = "cellId"
     let cellId = "cellId"


      let accessToken = "pk.eyJ1IjoibWMyODgyIiwiYSI6ImNqMjZjZjdsMDAwZTEzNHFmNXk1bGJpbDIifQ.jaXEzY40GjNuZSr6PVG9Tg"


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if userSessions.count == 0{
            return 1
        }
        return userSessions.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if userSessions.count == 0  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sessionCellId, for: indexPath) as! userSessionCell
        if let name = userSessions[indexPath.item].lastCheckPoint {
            cell.nameLabel.text = name
        }
        let path = getPathFromSession(session: userSessions[indexPath.item])
        cell.mapSnapShot.image = fetchMapSanpshot(path: path)
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 14)
    }
    
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserData()
        fetchUserSessionID {
          
            self.nSession.text = String(self.totalSession)
            self.travelDistance.text = String(self.totalDistance ) + " meters"
            self.travelTime.text = String(self.totalTime / 60 ) + " mins"
            self.nSteps.text = String(self.totalSteps) + " steps"
          
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize.height = 1000
        view.backgroundColor = UIColor(hex:"ECF0F1")
        setupNavigationController()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(userSessionCell.self, forCellWithReuseIdentifier: sessionCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(scrollView)
        view.addSubview(profileCoverImageView)
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(statView)
        view.addSubview(overviewLabel)
//        view.addSubview(completedLogLabel)
//        view.addSubview(collectionView)
        setupProfileImageView()
        setupProfileCoverImageView()
        setupStatView()
//        setupCollectionView()
        
    }
    
    func setupNavigationController(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogOut))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hex: "00B16A")

    }
    
    
    
    func setupStatView(){
        overviewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: statView.topAnchor, constant: -4).isActive = true
        overviewLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        statView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        statView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8).isActive = true
        statView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        statView.addSubview(sessionLabel)
        statView.addSubview(nSession)
        statView.addSubview(distanceLabel)
        statView.addSubview(travelDistance)
        statView.addSubview(timeLabel)
        statView.addSubview(travelTime)
        statView.addSubview(stepsLabel)
        statView.addSubview(nSteps)
        
        sessionLabel.topAnchor.constraint(equalTo: statView.topAnchor, constant: 4).isActive = true
        sessionLabel.leftAnchor.constraint(equalTo: statView.leftAnchor, constant: 16).isActive = true
        sessionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nSession.leftAnchor.constraint(equalTo: sessionLabel.rightAnchor, constant: 20).isActive = true
        nSession.topAnchor.constraint(equalTo: statView.topAnchor, constant: 4).isActive = true
        nSession.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
        distanceLabel.topAnchor.constraint(equalTo: sessionLabel.bottomAnchor, constant: 4).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: statView.leftAnchor, constant: 16).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 4).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: statView.leftAnchor, constant: 16).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stepsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4).isActive = true
        stepsLabel.leftAnchor.constraint(equalTo: statView.leftAnchor, constant: 16).isActive = true
        stepsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        travelDistance.leftAnchor.constraint(equalTo: sessionLabel.rightAnchor, constant: 20).isActive = true
        travelDistance.topAnchor.constraint(equalTo: sessionLabel.bottomAnchor, constant: 4).isActive = true
        travelDistance.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        travelTime.leftAnchor.constraint(equalTo: sessionLabel.rightAnchor, constant: 20).isActive = true
        travelTime.topAnchor.constraint(equalTo: travelDistance.bottomAnchor, constant: 4).isActive = true
        travelTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nSteps.leftAnchor.constraint(equalTo: sessionLabel.rightAnchor, constant: 20).isActive = true
        nSteps.topAnchor.constraint(equalTo: travelTime.bottomAnchor, constant: 4).isActive = true
        nSteps.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -4).isActive = true
    }
    
    func setupProfileCoverImageView() {
        //need x, y, width, height constraints
        profileCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileCoverImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileCoverImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        profileCoverImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupCollectionView(){
        
        completedLogLabel.topAnchor.constraint(equalTo: statView.bottomAnchor, constant: 8).isActive = true
        completedLogLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        completedLogLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: completedLogLabel.bottomAnchor, constant: 8).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
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
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        self.presentRootView()
    }
    
    
    
    
    func fetchUserSessionID(_ completion: @escaping  () -> Void ){
        var userSessionID = [String]()
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("userSession").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                Database.database().reference().child("Session").child(i).observeSingleEvent(of: .value, with: { (snapshot) in
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
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = defaultUser(dictionary: dictionary)
                if user.profileImageURL != nil{
                    self.profileImageView.loadImageUsingCacheWithUrlString((user.profileImageURL)!)
                }
                self.userNameLabel.text = user.name
            }
            
        }, withCancel: nil)
    }
    
   }


