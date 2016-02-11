//
//  CaptureSignatureViewController.swift
//  signature
//
//  Created by Vignesh on 2/10/16.
//  Copyright © 2016 vigneshuvi. All rights reserved.
//

import UIKit
import QuartzCore

protocol CaptureSignatureViewDelegate {
    func processCompleted(signImage: UIImage)
}

class CaptureSignatureViewController: UIViewController {
    
    @IBOutlet var captureButton: UIButton!
    var delegate: CaptureSignatureViewDelegate?
    var username : NSString?
    var signedDate : NSString?

    @IBAction func captureSign(sender: AnyObject) {
        
        //Create the AlertController
        let alertView: UIAlertController = UIAlertController(title: "Saving signature with name", message: "Please enter your name`", preferredStyle: .Alert)
        
        //Add a text field
        alertView.addTextFieldWithConfigurationHandler { textField -> Void in
            //TextField configuration
            textField.textColor = UIColor.blackColor()
            textField.placeholder = "Name";
        }
        
        //Add a text field
        alertView.addTextFieldWithConfigurationHandler { textField -> Void in
            //TextField configuration
            textField.textColor = UIColor.blackColor()
             textField.placeholder = "Date(DD/MM/YYYY)";
        }
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "No, thanks", style: .Cancel) { action -> Void in
            //Do some stuff
            alertView.dismissViewControllerAnimated(true, completion: nil);

        }
        alertView.addAction(cancelAction)
        
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Yes, please", style: .Default) { action -> Void in
            //Do some other stuff
            //Handel your yes please button action here
            let textField:UITextField = (alertView.textFields?[0])!;
            self.username = textField.text;
            let datetextField:UITextField = (alertView.textFields?[1])!;
            self.signedDate  = datetextField.text;
            if(self.username != nil && !self.username!.isEqualToString("") && self.signedDate != nil  && !self.signedDate!.isEqualToString(""))
            {
                alertView.dismissViewControllerAnimated(true, completion: nil);
                if let delegate = self.delegate {
                    let signedImage = self.imageWithView(self.signatureView, text:String(format:"By: %@, %@", self.username!, self.signedDate!));

                    delegate.processCompleted(signedImage);
                }
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        alertView.addAction(nextAction)

        //Present the AlertController
        self.presentViewController(alertView, animated: true, completion: nil)

    }
    
    
    @IBOutlet var signatureView: UviSignatureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imageWithView(view : UIView, text : NSString) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        
        // Setup the font specific variables
        let attributes :[String:AnyObject] = [
            NSFontAttributeName : UIFont(name: "Helvetica", size: 12)!,
            NSStrokeWidthAttributeName : 0,
            NSForegroundColorAttributeName : UIColor.blackColor()
        ]
        text.drawAtPoint(CGPointMake(view.frame.origin.x+10, view.frame.size.height-25), withAttributes: attributes);
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return img;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
