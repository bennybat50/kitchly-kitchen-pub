class CapitalizeText{
  String capitalize(String s) {
   if(s!=null && s!=''){
     return s[0].toUpperCase() + s.substring(1);
   }else if(s==null){
     return '';
   }else if(s==''){
     return '';
   }
  }
}