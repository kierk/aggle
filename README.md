# ![aggle logo](ios/icons/Icon-72.png?raw=true) Aggle

An open source mobile application serving as an alternative to Craigslist for fast local buying, haggling, and selling for cash.  

Do you wish you could window shop from home but can't believe the extreme shipping costs on sites like etsy?!?  Wish you could browse listings on craigslist without specifying exactly what you are looking for?  Have an item that you want to sell for cash on a deadline but fear listing on craigslist will bucket your item into an obscure category that won't allow it to reach the people who might not even know they need the item in their life?  

*NO LONGER!!* Aggle allows you to snap, list, sell.  The tinder-like swipe browsing allows you to search a mix of broad categories you care about (electronics, men's clothing, women's shoes) for items you will love right around the corner from where you live!  

This project is for Boston University's course EC500 Agile Software Development for ECE Applications.

## App Features

In our final sprint we had a huge amount of growth though everything isn't in it's final form we made more progress than any other sprint:
- Added zip code on login and local item only browsing accordingly
- Added ‘Settings’ page that pulls picture from fb and allows you to save changed zip code
- Switched from the ugly swipe function to a streamlined working view with Koloda
- Camera and picture upload now function properly, tested on phone, and take you to an item description page where you can update the database with the proper info
- Chat functionality added, then broken :(
- Added current seller listings page that shows listing after you post from images

Please see below for image examples of some of our new screens.

#### Home Page with Icon

The following photos will walk you through our basic control flow:

![icon](ss/icon.png?raw=true)

#### Login with Zipcode

![login](ss/login.png?raw=true)

#### Landing Page with Swipe Browsing

![browse](ss/browse.png?raw=true)

Check out the new icons and aesthetic improvements along the nav bar at the bottom!  When you move the photo it now changes from gree to red when the photo is being swiped in one direction or another.

#### Settings Page now with FB

![settings](ss/settings.png?raw=true)

#### Editable Zip Code

![settings_prompt](ss/settings_prompt.png?raw=true)

#### Use Camera or Photo Library to Post new items!

![post](ss/Post.png?raw=true)

#### See what items you have listed for sale!

![list](ss/Listings.png?raw=true)

#### Storyboard showing control flow

![storyboard](ss/main.png?raw=true)

#### Our new BETA Website!

![website](ss/website.png?raw=true)


## Repository Contents & Hierarchy

- `ios/` - This folder contains the main app code and project files
- `mockup/` - This folder contains icons in development as well as initial projections for layout and aethetics of the app
- `old/` - Old reference materials such as tutorials and segmented features of the app before they were merged into the master applciation
- `scratch/` - Various database and testing files
- `website/` - Contains the code for our BETA website @ http://maxphilipli.com/teamAggle.html (be sure to be in full screen with proper zoom) ;)

### Build Instructions

In order to run and test the most recent version of the app just clone the repository and open the following file with your Xcode program on an apple computer:  

`ios/aggle/aggle.xcworkspace`

- Please make sure you are working from the file listed as it is required to run projects utilizing cocoapods from this project file.

- Please also make sure you have installed cocoapods: Koloda, Firebase & JSQMessagesViewController (these can be installed via the requirements file by going into project folder, with cocoapods installed in your XCode, and running `pod install`)

The most recent version is targeted to be run and tested on iPhone 6s.

### Mission Goals:  
- [ ] Learn iOS, and develop a sweet app
- [ ] Develop an amazing backend to support the app
- [ ] Be champions in EC500
- [ ] ???
- [ ] :dancer: :dancer: :dancer:

