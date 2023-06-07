class Error {
  getStatus({status}) {
    switch (status) {
      case "MISSING_HEADERS":
        return true;
      case "EMPTY_EXTRA":
        return true;
      case "BAD_REQUEST":
        return true;
      case "NO_PENDING_ORDER":
        return true;
      case "EMAIL_NOT_EXIST":
        return true;
      case "ACCOUNT_EXIST":
        return true;
      case "ACCOUNT_NOT_EXIST":
        return true;
      case "KITCHEN_EXIST":
        return true;
      case "INVALID_PASSWORD":
        return true;
      case "TOKEN_NOT_PASSED":
        return true;
      case "INVALID_TOKEN":
        return true;
      case "WRONG_TOKEN_ID":
        return true;
      case "CODE_EXPIRED":
        return true;
      case "CODE_NOT_EXIST":
        return true;
      case "KITCHEN_NOT_EXIST":
        return true;
         case "KITCHEN_CLOSED":
        return true;
      case "DISH_NOT_EXIST":
        return true;
      case "USER_NAME_EXIST":
        return true;
      case "NO_FILE_ATTACHMENT":
        return true;
      case "INVALID_OPTION":
        return true;
      case "INVALID_OPTION_ENTRY":
        return true;
      case "EMPTY_EXTRA":
        return true;
      case "EXTRAS_NOT_EXIST":
        return true;
      case "EXTRA_NOT_EXIST": 
        return true;
      case "MEAL_NOT_EXIST":
        return true;
      case "EMPTY_EXTRA":
        return true;
      case "DISH_NOT_EXIST":
        return true;
      case "EMPTY_OPTION": 
        return true;
      case "MENU_NOT_EXIST": 
        return true;
      case "ORDER_NOT_EXIST":
        return true;
      case "ORDER_UNMODIFIED":
        return true;
      case "INVALID_DISH_STATUS":
        return true;
      case "INVALID_ORDER_CONFIRM":
        return true;
      // case "WRONG_DEVICE_ID":
      //   return true;
      case "UNAUTHORIZED_SIGNOUT":
        return true;
      case "CODE_NOT_EXIST":
        return true;
      case "INVALID_DELIVERY_METHOD":
        return true;
      case "PASSWORD_SECURITY":
        return true;
      case "PASSWORD_CHANGED":  
        return true;
        
      default:
        return false;
    }
  }
}
