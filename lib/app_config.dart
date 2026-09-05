var this_year = DateTime.now().year.toString();

class AppConfig {
  // configure this
  static String copyright_text =
      "© Bicholan $this_year"; //it will show in your splash screen
  static String app_name =
      "Bicholan"; //it will show in your splash screen
  static String purshase_code =
      'your_purchase_code'; // enter your purchase_code here
  static const bool HTTPS = true; //if you are using localhost set it to false
  static const DOMAIN_PATH = "bicholan.codenetbiztech.com"; // enter your domain name  here
  static const String MAP_KEY = "AIzaSyA_usa-2matJnaEuxFvNag8qhXL51w4vJM";

  // do not configure these below
  static const String API_ENDPATH = "api";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";
}
