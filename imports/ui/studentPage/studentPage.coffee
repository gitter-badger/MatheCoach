require "./studentPage.jade"
require "/imports/ui/activityGraph/activityGraph.coffee"
require "/imports/ui/submissionsList/submissionsList.coffee"

Template.studentPage.viewmodel
  studentId : -> FlowRouter.getParam "studentId"
  student : -> Meteor.users.findOne _id : @studentId()

Template.studentOwnPage.viewmodel
  studentId : -> Meteor.userId()
  student : -> Meteor.users.findOne _id : @studentId()

Template.studentPageDisplay.viewmodel
  name : -> "#{@profile().firstName} #{@profile().lastName}"
  page : 1
  showMore : -> @page @page()+1
