# BeerClub

# How To Install
1. run `bundle install`
2. run `rails db:create` with rails 5
3. run `rails db:migrate`
4. run `rspec`
5. run `rails server`


- heroku server: [`https://beerclub-rails5.herokuapp.com/`](https://beerclub-rails5.herokuapp.com/)
- database admin [`https://beerclub-rails5.herokuapp.com/admin`](https://beerclub-rails5.herokuapp.com/admin)
- document: [`https://beerclub-rails5.herokuapp.com/documentation`](https://beerclub-rails5.herokuapp.com/documentation)
- Rspec test: [`https://beerclub-rails5.herokuapp.com/coverage/index.html#_AllFiles`](https://beerclub-rails5.herokuapp.com/coverage/index.html#_AllFiles)
- front end: [`https://github.com/pdkproitf/BeerClubFront`](https://github.com/pdkproitf/BeerClubFront)

6. Account
- Admin account (click on `login`): `ryanpham@gmail.com` password: `Aa123456!`
- Customer account (click on `see my passport`): `vadus.by@gmail.com`, password: `Aa123456!`

# Requires Details:
Info on the Beer Club:
http://calgary.craftbeermarket.ca/craft-club

List of their beers, and the categories (click on the lists on the left hand side):
http://calgary.craftbeermarket.ca/beer/wheat-ales

The assignment is to create a backend that can handle some of the tasks for this application. Note that there will be a mobile app that talks to this backend (you don't need to build one, just support one!), so the app will interact with the backend via a JSON API. That said, there should be a web interface for entering beers for the bar owner.

- The only users that will be able to log into the web interface are Admins.  Admin users are able to add/edit/delete/archive the list of beers. It should be possible to create a new Admin account.

- Admins will first enter the beer categories. Samples from Craft: Ambers & Red Ales, White Ales, Wheat Ales, etc.

- Admins will then enter the beers that are currently available at the bar. There will be a drop down inside the new beer form for category that lets you choose one of the pre-entered categories

- App users, anonymously without logging in, are able to obtain a list of all current beverages in JSON format. All of the information used to display a list of beers should come in a single API call to limit the number of API calls needed before the app is useful. The category should come through as a string in that same API request.

- You shouldn't be able to delete a category if there are any beers that are using it.

- The admin users should be able to "Archive" a beer. This is when the bar stops serving that beer. If a beer is archived, it shouldn't show up in the list of beers when retrieved by an anonymous app user via API. It should still exist in the database so that it can be returned by users that drank it before it was archived.

A beer should have the following information:

- Manufacturer
- Name
- Category
- Country
- Price
- Description

You don't need to do this for the assignment, but if you have time, you get bonus grades:

- Create a new class of user called Customer. Customers would sign up for an account through the app. 

- There should be an API for a Customer to add a beer to their passport once they've consumed it.

- When a Customer retrieves the list of beers, it should include all the ones they’ve consumed, as well as all beers that are available that they haven't tried yet.
