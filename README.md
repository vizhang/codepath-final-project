# columbus

###UI Mocks
##Spash Page

Login With Instagram Page

Discover Page
![alt tag](https://github.com/vizhang/columbus/blob/master/1-discover.png)

Discover Map Page
![alt tag](https://github.com/vizhang/columbus/blob/master/1-discovermap.png)

Favourites Page
![alt tag](https://github.com/vizhang/columbus/blob/master/2-favorites.png)

Adding Favourites Page

Profile Page
![alt tag](https://github.com/vizhang/columbus/blob/master/3-profile.png)

Friends Page
![alt tag](https://github.com/vizhang/columbus/blob/master/4-friends.png)

Time spent: `10-12`

### Features

#### Required

- [x] User can sign in using OAuth login flow 7:22pm - 7:50 figuring it out still...
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

#### Optional

- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] Retweeting and favoriting should increment the retweet and favorite count.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [ ] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
