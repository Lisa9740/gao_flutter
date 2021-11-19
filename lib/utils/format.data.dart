class FormatData{
  static toArray(str){
    var formattedStr = str.toString();
    return formattedStr.split(' ').map((String string) => string).toList();
  }
}