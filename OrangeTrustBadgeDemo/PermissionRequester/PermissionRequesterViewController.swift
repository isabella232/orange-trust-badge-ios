//
//  PermissionRequesterViewController.swift
//  ESSTrustBadge_iOS
//
//  Created by Marc Beaudoin on 23/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit
import OrangeTrustBadge

protocol PermissionRequesterDelegate {
    // Request speech recongnition authorization
    func requestSpeechRecognitionAuthorization(completionHandler: @escaping ()->Void)
    
    // Request media library authorization
    func requestMediaLibraryAuthorization(completionHandler: @escaping ()->Void)
    
    // Request motion & activity authorization
    func requestMotionActivityAuthorization(completionHandler: @escaping ()->Void)
    
    // Request healthkit authorization
    func requestHealthKitAuthorization(completionHandler: @escaping ()->Void)
    
    // Request photoLibrary authorization
    func requestPhotoLibraryAuthorization(completionHandler: @escaping ()->Void)
    
    // Request camera authorization
    func requestCameraAuthorization(completionHandler: @escaping ()->Void)
    
    // Request calendar authorization
    func requestCalendarAuthorization(completionHandler: @escaping ()->Void)
    
    // Request reminders authorization
    func requestReminderAuthorization(completionHandler: @escaping ()->Void)
    
    // Request microphone authorization
    func requestMicrophoneAuthorization(completionHandler: @escaping ()->Void)
    
    // Request contacts authorization
    func requestContactAuthorization(completionHandler: @escaping ()->Void)
    
    // Request homekit authorization
    func requestHomeKitAuthorization(completionHandler: @escaping ()->Void)
    
    // Request Access to UserLocation in order to show them in iOS Preferences Panel
    func requestLocationAuthorization(completionHandler: @escaping ()->Void)
    
    // Request Bluetooh Sharing authorization
    func requestBluetoothSharingAuthorization(completionHandler: @escaping ()->Void)

    func didFinishPerformRequests()
}


class PermissionRequesterViewController: UITableViewController {
    
    let bundle = Bundle(for: TrustBadge.self)
    var permissions: [ElementType] = ElementType.regularDevicePermissions
    
    public var delegate: PermissionRequesterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let label = tableView.tableHeaderView?.subviews.first as? UILabel {
           label.text = NSLocalizedString("requester-section-title", comment: "")
        }
        tableView.tableFooterView = UIView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.title = NSLocalizedString("requester-access-continue", comment: "")
    
        permissions.forEach {
            PersonalData.shared.updateConfiguredPermissions(with: $0)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let permission = permissions[indexPath.row]
        let key = "landing-\(permission.name)-name"
        cell.textLabel?.text = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
        
        var permissionEnable = permission.isEnabled
        if !permission.isAuthorizationRequested {
            permissionEnable = PersonalData.shared.configuredDevicePermissions.contains(permission) && permissionEnable
        }
        
        if permissionEnable {
            if permission.isAuthorizationRequested {
                cell.accessoryType = .checkmark
                cell.selectionStyle = .none
                cell.detailTextLabel?.text = NSLocalizedString("requester-access-requested", comment: "")
            } else {
                cell.accessoryType = .none
                cell.selectionStyle = .blue
                cell.detailTextLabel?.text = nil
            }
        } else {
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.detailTextLabel?.text = NSLocalizedString("requester-access-disabled", comment: "")
            cell.textLabel?.textColor = .lightGray
            cell.detailTextLabel?.textColor = .lightGray
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        var permission = permissions[indexPath.row]
        guard !permission.isAuthorizationRequested, permission.isEnabled else { return }

        let completionHandler: (()->Void) = {
            permission.isAuthorizationRequested = true
            DispatchQueue.main.async {
                tableView.reloadRows(at: [indexPath], with: .none)                
            }
        }

        switch permission {
        case .location:
            delegate?.requestLocationAuthorization(completionHandler: completionHandler)
            
        case .contacts:
            delegate?.requestContactAuthorization(completionHandler: completionHandler)
            
        case .photoLibrary:
            delegate?.requestPhotoLibraryAuthorization(completionHandler: completionHandler)
        
        case .media:
            delegate?.requestMediaLibraryAuthorization(completionHandler: completionHandler)
        
        case .calendar:
            delegate?.requestCalendarAuthorization(completionHandler: completionHandler)
        
        case .camera:
            delegate?.requestCameraAuthorization(completionHandler: completionHandler)
        
        case .reminders:
            delegate?.requestReminderAuthorization(completionHandler: completionHandler)
        
        case .bluetoothSharing:
            delegate?.requestBluetoothSharingAuthorization(completionHandler: completionHandler)
        
        case .microphone:
            delegate?.requestMicrophoneAuthorization(completionHandler: completionHandler)
        
        case .speechRecognition:
            delegate?.requestSpeechRecognitionAuthorization(completionHandler: completionHandler)
        
        case .health:
            delegate?.requestHealthKitAuthorization(completionHandler: completionHandler)
        
        case .homekit:
            delegate?.requestHomeKitAuthorization(completionHandler: completionHandler)
        
        case .motionFitness:
            delegate?.requestMotionActivityAuthorization(completionHandler: completionHandler)
        
        default:
            break
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var permission = permissions[indexPath.row]
        return !permission.isAuthorizationRequested
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var permission = permissions[indexPath.row]
        let title = NSLocalizedString(permission.isEnabled ? "requester-access-disable-action" : "requester-access-enable-action", comment: "")
        
        return [UITableViewRowAction(style: (permission.isEnabled ? .destructive : .normal), title: title, handler: { (rowAction, indexPath) in
            permission.isEnabled = !permission.isEnabled
            self.permissions[indexPath.row] = permission
            PersonalData.shared.updateConfiguredPermissions(with: permission)
            
            tableView.reloadRows(at: [indexPath], with: .none)
        })]
    }
    
    //MARK: IBActions
    @IBAction func `continue`(_ sender: Any) {
        if isBeingPresented {
            super.dismiss(animated: true) {
                self.delegate?.didFinishPerformRequests()
            }
        } else {
            self.delegate?.didFinishPerformRequests()
        }
    }
}

extension ElementType {
    
    enum State: Int {
        case unknown
        case requested
        case enabled
        case disabled
    }
    
    var isAuthorizationRequested: Bool {
        get {
            let state = State(rawValue: UserDefaults.standard.integer(forKey: name))
            return  state == .requested
        }
        set {
            UserDefaults.standard.set(State.requested.rawValue, forKey: name)
        }
    }

    var isEnabled: Bool {
        get {
            let state = State(rawValue: UserDefaults.standard.integer(forKey: name))
            return state != .disabled
        }
        set {
            UserDefaults.standard.set(newValue ? State.enabled.rawValue : State.disabled.rawValue, forKey: name)
        }
    }
}
