class Validation{
  String text(String value){
    if (value.length == 0) {
      return "Field is required";
    } else {
      return null;
    }
  }

  String oneNumber(String value){
    if (value.length == 0) {
      return "Field is required";
    } else if(value.contains(" ") || value.contains("-")|| value.contains("/")|| value.contains("*")|| value.contains("_")){
      return "No special character allowed\n e.g - , / , *, _";
    }else {
      return null;
    }
  }

  String oneNumberAllow(String value){
     if(value.contains(" ") || value.contains("-")|| value.contains("/")|| value.contains("*")|| value.contains("_")){
      return "No special character allowed\n e.g - , / , *, _";
    }else {
      return null;
    }
  }

  String validateUserName(String value){
    if (value.length == 0) {
      return "Username is required";
    }else if(value.contains(" ") || value.contains("-")){
      return "No space allowed use _ e.g user_name instead";
    } else {
      return null;
    }
  }

  String email(String value){
    String expn = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";
    RegExp regExp = new RegExp(expn);
    if (value.length == 0) {
      return "Field is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String phone(String value){
    String pattern = r'(^(?:[+0]9)?[0-9]{6,11}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
          return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
          return 'Please enter valid mobile number';
    }
    return null;
  
  }

  String password(String value, int less){

    bool hasUppercase = value.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = value.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = value.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters = value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (value.length == 0) {
      return "Password is required";
    } else if (value.length <= less ) {
      return "Mininum of $less characters.";
    } else if (!hasUppercase ) {
      return "Password must contain at least\one capital letter e.g(A).";
    }else if (!hasDigits ) {
      return "Password must contain at least a digit e.g(1)";
    }else if (!hasLowercase ) {
      return "Password must contain at least\none small letter e.g(a)";
    }else {
      return null;
    }
  }

  String confirmPassword(String value1,value2, int less){
    if (value1.length == 0) {
      return "Password is required"; 
    } else if (value1.length <= less ) {
      return "Mininum of $less characters";
    }else if (value1.toString() != value2.toString() ) {
      return "Please reconfirm your password";
    } else {
      return null;
    }
  }

  String validateCode(String value) {
    if (value.length == 0) {
      return "Please enter a verification code";
    } else if (value.length <= 5 || value.length > 6) {
      return "6 digits only";
    } else {
      return null;
    }
  }
}