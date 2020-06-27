# TeamUp-

Motivation 

When you are stuck in a group with an odd number of people, or you are an introvert, and the professor wants you to partner up in groups with even numbers of people. Conversely, maybe you would like to do an external project or competition but could not find a teammate. Then what will you do?

Many would have trouble finding a partner and some will end up partnering with someone they do not really like. Or some do not even find a partner at all!

Is there no other way to find groupmates and not waste precious time?


Aim 

We hope to make a groupmate matching system for university students in Singapore that is efficient and engaging through dating-like interaction platforms. (e.g Tinder but pg13) 





User Stories

As a student who is in an odd numbered group but has to work in an even numbered group or vice versa, I would like to find a teammate that can fill up the gap. 

As a student who is an introvert, I want to be able to look for teammates without any face-to-face interaction.

As a student who is having a hard time finding groupmates for an external project/competition, I want to be able to find them more efficiently.

As an administrator who wants to prevent abuse of the system, I want to be able to identify abusers, warn them and ban them if they continue to cause problems.

As a university professor, I would like to create projects so that students can join and find their respective teammates with ease.

As a competition organiser that targets university students, I would like to create competitions so that students can join and find their respective teammates with ease.

As a student, I would like to chat with other potential members before allowing them to join my group so that I can create my ideal group.

As a student who have a lot of work to do, I would like to search for the projects I want efficiently so that I do not have to waste any precious time



Scope of Project

We will be using Swift on Xcode to create an Apple mobile application. The following features of our application are :

The Teammate Matching System provides a tinder-like interface for students to choose suitable teammates based on their bios.

The Project Filter System allows a systematic management of projects with different types and purposes. An option will be available for the user to choose to be a creator or a participant. By being a creator, Professors as well as competition organisers can create module based projects/competitions for students to join. Students also can create independent projects to find teammates, which other users can search for these projects by choosing the relevant categories.

The Chat System provides both private 1-1 chat and group chat. The group chat feature eases the communication and team forming for larger scaled projects.

The Project Creation System allows creators to create their own projects for other users to join.

Features to be completed by the mid of June: 

1. Matching system
Allow the students to swipe left or right to accept or reject someone. Upon acceptance, they will be able to initiate a conversation through online texting.

2. Creating databases with Firebase 
To save user’s info and the projects they have undertaken as well as the teammates they have matched

3. Project Creation System
Allow users who choose to be creators to create projects for other users to join

Features to be completed by the mid of July: 

1. Filtering system
Allow the students to search and select the modules/competition/project they want to join.

2. Chat system
Allow teammates to be able to create a group chat to intercommunicate with each other as well as individuals who want to have a private 1-1 chat



How are we different from other platforms?

Tinder: The target audience is different. TeamUp! targets university students that are looking for teammates while Tinder is a dating platform. 

GitHub: Unlike Github which is harder to use, TeamUp! has a more user-friendly design which enables students to find the projects they want more easily.

Trello: Trello is more for business employers to check their employees progress on their projects instead of allowing users to find teammates.




Providing Evidence of creating databases with Firebase

We are using Firebase, a mobile platform developed by Google, to store and manage TeamUp!’s data. 

Firebase’s authentication feature allows us to store the user’s information and manage each user’s accessibility. When the user registers a new account, a new identifier is created in Firebase and respective information (i.e. user’s name, course, email and password) are saved under Firebase’s database. 

When the user logs in as a registered user, the Firebase compares the identifier (i.e. user’s email) and the password to check the authentication.

We also use Firebase’s database and cloud storage to store and manage the project/modules’ information for the project creation system. 

By creating a loadData() function, we are able to get documents containing the projects/modules’ information from firebase to show in a tableView format on our application. We also have a checkforUpdates() function which will allow newly added projects/modules to update automatically in our tableView.



Providing Evidence of creating Swiping system with KolodaView

KolodaView is a class designed to simplify the implementation of Tinder-like cards on iOS. It adds convenient functionality such as a UITableView-style dataSource/delegate interface for loading views dynamically and efficient view loading/unloading.

We have also created a revert button to allow users to go back to previous profiles of people in case they have changed their mind. 

A didSelectCardAt koloda function was also created to allow users to select the profile of the other participant by tapping the card. This will allow the user to view more details about their profile and subsequently match them.














