# columbus

##UI Gestures and Navigation
- [ ] From discovery page, user can swipe down to reveal the map. Can also swipe up (from the white space) to go back
- [ ] From discovery page, user can swipe left to see profile page for log-out
- [ ] From discovery page, user can swipe right to see favourites page

###Spash Page (Victor)
- [ ] Load some image as the splash screen

###Login Page (Victor)
- [ ] Login with instagram and complete OAuth steps
- [ ] Retain session for logged-in user

###Discover Page 
![alt tag](https://github.com/vizhang/columbus/blob/master/1-discover.png)
- [ ] Turn on GPS Access Priveledges
- [ ] Background changes to settings steps if user clicked on "Cancel" for permissions
- [ ] API call to Instagram and fetch images from user location
- [ ] Create model to store data from instagram
- [ ] Optional: User can click on an image and they get details?

###Discover Map Page
![alt tag](https://github.com/vizhang/columbus/blob/master/1-discovermap.png)
- [ ] Load map from SDK (ie. Mapbox)
- [ ] Get data from model and show thumbnails on the map (do we have to resize)
- [ ] Optional: Separate cells for content types (instagram, twitter, etc..)
- [ ] Optional: User can tap image and get details?

###Favourites Page
![alt tag](https://github.com/vizhang/columbus/blob/master/2-favorites.png)
- [ ] Loads user saved locations from Parse API
- [ ] Make API call to Instagram and fetch images from user loaded locations
- [ ] Create model to store data from instagram
- [ ] Show headers for each location
- [ ] Plus sign in the navigational bar to segue to "Adding Favourites Page"
- [ ] Optional: Separate cells for content types (instagram, twitter, etc..)
- [ ] Optional: User can click on a location and get the discovery view for that location
- [ ] Optional: Right swiping on a header removes the city from your favourites

###Adding Favourites Page
- [ ] Has a search bar that makes API call to location searches (Google API)
- [ ] As user is typing, the search loads in the background
- [ ] Load list of locations in a table view
- [ ] Tap on a star button in the cell to add it to your favourites

###Profile Page
![alt tag](https://github.com/vizhang/columbus/blob/master/3-profile.png)
- [ ] Get profile image and username from Instagram
- [ ] Button for user to log-out

####Optional
###Friends Page
![alt tag](https://github.com/vizhang/columbus/blob/master/4-friends.png)

Time spent: to be tracked
