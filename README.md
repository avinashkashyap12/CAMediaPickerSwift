# CAMediaPickerSwift
CAMediaPicker is swift library very similar to UIImagePickerController. Its allow to select multiple images at a time from photo albums and photo libraries. This picker is implemeted using native "Photos Framework". It is easy to integrate in any project with few lines of code. Its also allow to add image using device camera.

### CAMediaPickerSourceType
CAMediaPicker is having two type of Source
   1. image:
      Source type "image" provide a user interface for taking new picture/image  using device camera.
  2. photoAlbum:
        Source type "photoAlbum" provide a user interface for choosing multiple images/pictures from  saved pictures.

###CAMediaPickerDelegate
    The methods of this protocol notify delegate when user either select images or cancel the picker operation. CAMediaPicker having three delegate methods for sending the message to owner controller on user action.
    
    1. mediaPickerControllerDidCancel():
        tell the delegate that user cancelled the picker operation.
        
    2. mediaPickerControllerDidSelectedImage(assets:[UIImage])
        tell the delegate that user has selected images.
        
    3. mediaPickerControllerDidFailWithAuthorizationStatus(status: PHAuthorizationStatus)
        tell the delegate that application dows not have enough permission for perform picker operation.


## The sample application show its use.

### 1. Add image using device camera

     let pickerController = CAMediaManager.init(withController: self)
     pickerController.delegate = self
     pickerController.presentMediaPickerController(withSource: .image)
Above 3 lines are code enough for perform an picker operation for click new image.

### 2. Add images from saved photos

    let pickerController = CAMediaManager.init(withController: self)
    pickerController.delegate = self
    pickerController.presentMediaPickerController(withSource: .photoAlbum)
And These 3 lines are code enough for perform an picker operation for select multiple images from saved photos.

Implement delegate method for getting selected image(s).

    func mediaPickerControllerDidSelectedImage(assets: [UIImage]) {
         // perform further operation after selecting images
    }
    func mediaPickerControllerDidCancel() {
            print("cancel selection")
    }
    func mediaPickerControllerDidFailWithAuthorizationStatus(status: PHAuthorizationStatus) {
        print("Authorization fail")
        //display an alert message for getting permission for perform picker operations
    }
    
CAMediaPicker also allow to disable multiple choice option (by defult multiple choice option is enable),
just add below line of code for disable mulple choice option.

    pickerController.disableMultipleSelection()
    

