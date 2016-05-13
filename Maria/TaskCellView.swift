//
//  TaskCellView.swift
//  Maria
//
//  Created by ShinCurry on 16/5/10.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Cocoa
import Aria2


class TaskCellView: NSTableCellView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // Drawing code here.
        actionButton.target = self
        
        aria2.onStart = { flag in
            if flag {
                self.status = "active"
            }
        }
        aria2.onPause = { flag in
            if flag {
                self.status = "paused"
            }
        }
    }
    
    var fileName: String? {
        didSet {
            if let ext = fileName!.componentsSeparatedByString(".").last {
                let taskIconImage = NSWorkspace.sharedWorkspace().iconForFileType(ext)
                taskIconImage.size = taskTypeImageView.frame.size
                taskTypeImageView.image = taskIconImage
            }
        }
    }
    let aria2 = Aria2.shared
    
    var gid: String = ""
    var isBtDownload: Bool = false
    var status: String = "active" {
        didSet {
            switch status {
            case "waiting":
                fallthrough
            case "active":
                actionButton.action = #selector(actionPause)
                actionButton.image = NSImage(named: "PauseButton")
                taskStatusLabel.stringValue = "Downloading"
            case "paused":
                actionButton.action = #selector(actionRestart)
                actionButton.image = NSImage(named: "RestartButton")
                taskStatusLabel.stringValue = "Paused"
            case "complete":
                actionButton.image = NSImage(named: "CompleteButton")
                taskStatusLabel.stringValue = "Complete"
            case "removed":
                actionButton.action = #selector(actionRestart)
                actionButton.image = NSImage(named: "RestartButton")
                taskStatusLabel.stringValue = "Removed"
            case "error":
                actionButton.image = NSImage(named: "RestartButton")
                taskStatusLabel.stringValue = "Error"
            default:
                break
            }
            
        }
    }
    
    @IBOutlet weak var dot1: NSTextField!
    @IBOutlet weak var dot2: NSTextField!
    @IBOutlet weak var dot3: NSTextField!
    @IBOutlet weak var dot4: NSTextField!
    
    
    @IBOutlet weak var taskTypeImageView: NSImageView!
    @IBOutlet weak var taskTitleLabel: NSTextField!
    @IBOutlet weak var taskProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var taskFileSizeLabel: NSTextField!
    @IBOutlet weak var taskSpeedLabel: NSTextField!
    @IBOutlet weak var taskRemainingTimeLabel: NSTextField!
    @IBOutlet weak var taskProgressLabel: NSTextField!
    
    @IBOutlet weak var taskStatusLabel: NSTextField!
    
    @IBOutlet weak var actionButton: NSButton!
    
    func actionRestart() {
        aria2.start(gid)
    }
    func actionPause() {
        aria2.pause(gid)
    }
    func actionStop() {
        
    }
    
    var data: Aria2Task? {
        didSet {
            updateView(data!)
        }
    }
    
    func updateView(task: Aria2Task) {
        gid = task.gid!
        status = task.status!
        isBtDownload = task.isBtTask!
        if isBtDownload {
            taskTypeImageView.image = NSImage(named: "TorrentIcon")
        } else {
            fileName = task.fileName!
        }
        taskTitleLabel.stringValue = task.title!
        taskSpeedLabel.stringValue = "⬇︎ " + task.speed!.downloadString + " ⬆︎ " + task.speed!.uploadString
        taskProgressIndicator.doubleValue = task.progress
        taskProgressLabel.stringValue = task.progressString
        taskFileSizeLabel.stringValue = task.fileSizeString
        taskRemainingTimeLabel.stringValue = task.remainingString
    }
}
