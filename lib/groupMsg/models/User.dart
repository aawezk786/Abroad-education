/*
Written by Olusola Olaoye
Copyright © 2020

 */

class gUser
{
  String uid;

  String username;

  String fullName;

  String email;

  String photoURL;

  String bio;

  String location;

  String dateCreated;

  String settings;

  gUser({this.uid, this.username, this.fullName, this.email, this.photoURL, this.bio, this.location, this.dateCreated, this.settings});

  factory gUser.fromMap(Map<dynamic, dynamic> map)
  {
    return gUser(
      uid: map['id'],
      username: map['username'],
      fullName: map['fullname'],
      email: map['email'],

      photoURL: map['photourl'],
      bio: map['bio'],
      location: map['location'],
      dateCreated: map['datecreated'],
      settings: map['settings'],


    );
  }
}

