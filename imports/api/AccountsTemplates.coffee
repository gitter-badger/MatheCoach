T9n.setLanguage "de"

AccountsTemplates.configure
  defaultLayout : "layout"
  defaultLayoutRegions : {}
  defaultContentRegion : "main"
  showForgotPasswordLink: true
  showResendVerificationEmailLink : true
  sendVerificationEmail : true
  enforceEmailVerification : false
  overrideLoginErrors: true
  enablePasswordChange: true
  confirmPassword: true
  continuousValidation: false

pwd = AccountsTemplates.removeField "password"
AccountsTemplates.removeField "email"
AccountsTemplates.addFields [
  _id : "username"
  type : "text"
  displayName : "username"
  required : true
  minLength : 5
,
  _id : "email"
  type : "email"
  required : true
  displayName : "email"
  re: /.+@(.+){2,}\.(.+){2,}/
  errStr : "Invalid email"
,
  pwd
]

AccountsTemplates.configureRoute "signIn"
AccountsTemplates.configureRoute "signUp"
AccountsTemplates.configureRoute "changePwd"
AccountsTemplates.configureRoute "forgotPwd"
AccountsTemplates.configureRoute "resetPwd"
