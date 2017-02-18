{ Mongo } = require "meteor/mongo"
{ Meteor } = require "meteor/meteor"
{ Tracker } = require "meteor/tracker"
{ Submissions } = require "./submissions.coffee"
{ SchoolClasses } = require "./schoolClasses.coffee"
{ Accounts } = require "meteor/accounts-base"
{ Email } = require "meteor/email"

md5 = require "md5"

userProfileSchema = new SimpleSchema
  firstName :
    type : String
    optional : true
  lastName :
    type : String
    optional : true
  dateOfBirth :
    type : String
    optional : true
  street :
    type : String
    optional : true
  plz :
    type : String
    optional : true
  city :
    type : String
    optional : true
  phone :
    type : String
    optional : true
  mobile :
    type : String
    optional : true
  referenceNumber :
    type : String
    optional : true
  schoolClassId :
    type : String
    optional : true
  lastActive :
    type : Date
    optional : true
  useKaTeX :
    type : Boolean
    optional : true
  navbarSize :
    type : Number
    optional : true
  contentSize :
    type : Number
    optional : true
  keypadSize :
    type : Number
    optional : true
  showViewportSize :
    type : Boolean
    optional : true
exports.userProfileSchema = userProfileSchema

userSchema = new SimpleSchema
  username :
    type : String
    optional : true
  emails :
    type : Array
    optional : true
  "emails.$" :
    type : Object
  "emails.$.address" :
    type : String
    regEx : SimpleSchema.RegEx.Email
  "emails.$.verified" :
    type : Boolean
  createdAt :
    type : Date
  profile :
    type : userProfileSchema
    optional : true
  services :
    type : Object
    optional : true
    blackbox : true
  roles :
    type : [String]
    optional : true
  heartbeat :
    type : Date
    optional : true
Meteor.users.attachSchema userSchema

Meteor.users.helpers
  fullName : ->
    "#{@profile.firstName} #{@profile.lastName}"
  avatar : ->
    hash = md5(@emails[0]?.address.toLowerCase() ? "0")
    "https://www.gravatar.com/avatar/#{hash}"
  submissions : ->
    Submissions.find
      userId : @_id()
    ,
      sort :
        date : -1
  lastSubmission : ->
    Submissions.findOne
      userId : @_id()
    ,
      sort :
        date : -1
  submissionsPage : (page = 1) ->
    Submissions.find
      userId : @_id()
    ,
      sort :
        date : -1
      limit : 10*page
  schoolClass : ->
    SchoolClasses.findOne
      _id : @profile.schoolClassId
  isMentor : ->
    Roles.userIsInRole @_id(), "mentor"
  isAdmin : ->
    Roles.userIsInRole @_id(), "admin"
  hasTeacher : -> @schoolClass?.teacher?

exports.sendVerificationEmail = new ValidatedMethod
  name : "sendVerificationEmail"
  validate :
    new SimpleSchema
      userId :
        type : String
    .validator()
  run : ({ userId }) ->
    if Meteor.isServer
      console.log "sending verificationEmail to #{userId}"
      Accounts.sendVerificationEmail userId

  exports.sendTestEmail = new ValidatedMethod
    name : "sendTestEmail"
    validate :
      new SimpleSchema
        text :
          type : String
      .validator()
    run : -> ({ text }) ->
      if Meteor.isServer
        console.log "sending test mail"
        Email.send
          from : "MatheCoach <pille@mac.com>"
          to : "pille@mac.com"
          subject : text
          text : text

exports.toggleRole = new ValidatedMethod
  name : "toggleRole"
  validate :
    new SimpleSchema
      userId :
        type : String
      role :
        type : String
    .validator()
  run : ({ userId, role }) ->
    unless @userId
      throw new Meteor.Error "not logged-in"
    unless Roles.userIsInRole @userId, "admin"
      throw new Meteor.Error "not admin"
    if role is "admin" and not
    Roles.userIsInRole @userId, "superAdmin"
      throw new Meteor.Error "not superAdmin"
    if Roles.userIsInRole userId, role
      Roles.removeUsersFromRoles userId, role
    else
      Roles.addUsersToRoles userId, role

exports.removeUserFromClass = new ValidatedMethod
  name : "removeUserFromClass"
  validate :
    new SimpleSchema
      id :
        type : String
    .validator()
  run : ({ id }) ->
    unless @userId
      throw new Meteor.Error "not logged-in"
    unless Roles.userIsInRole @userId, "admin"
      throw new Meteor.Error "not admin"
    Meteor.users.update _id : id,
      $unset :
        "profile.schoolClassId" : ""

exports.updateUserProfile = new ValidatedMethod
  name : "updateUserProfile"
  validate :
    new SimpleSchema
      profile :
        type : userProfileSchema
      userId :
        type : String
        optional : true
    .validator()
  run : ({ profile, userId }) ->
    unless @userId
      throw new Meteor.Error "not logged-in"
    unless Roles.userIsInRole @userId, "admin"
      if Roles.userIsInRole @userId, "mayNotEditOwnProfile"
        throw new Meteor.Error "may not edit own profile"
      userId = @userId
    unless userId?
      throw new Meteor.Error "no userId"
    Meteor.users.update userId,
      $set :
        profile : profile

exports.deleteUser = new ValidatedMethod
  name : "deleteUser"
  validate :
    new SimpleSchema
      id :
        type : String
    .validator()
  run : ({id}) ->
    unless @userId
      throw new Meteor.Error "not logged-in"
    unless Roles.userIsInRole @userId, "admin"
      throw new Meteor.Error "not admin"
    submissionsRemoved = Submissions.remove userId : id
    usersRemoved = Meteor.users.remove _id : id
    if Meteor.isServer
      console.log "delete user: #{id}"
      console.log "#{submissionsRemoved} submissions removed."
      console.log "#{usersRemoved} user removed."

exports.deleteSubmissions = new ValidatedMethod
  name : "deleteSubmissions"
  validate :
    new SimpleSchema
      userId :
        type : String
    .validator()
  run : ({userId}) ->
    unless @userId
      throw new Meteor.Error "not logged-in"
    unless Roles.userIsInRole @userId, "admin"
      throw new Meteor.Error "not admin"
    submissionsRemoved = Submissions.remove userId : userId
    if Meteor.isServer
      console.log "delete all submissions for user: #{userId}"
      console.log "#{submissionsRemoved} submissions removed."

if Meteor.isServer
  Meteor.publish "mentorData", ->
    Roles.getUsersInRole "mentor"

  Meteor.publishComposite "allUserData", ->
    find : ->
      if Roles.userIsInRole @userId, "admin"
        Meteor.users.find()

if Meteor.isClient
  Meteor.subscribe "mentorData"
  Tracker.autorun ->
    if Roles.userIsInRole @Meteor.userId(), "admin"
      Meteor.subscribe "allUserData"
