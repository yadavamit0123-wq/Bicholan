-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers
-keep @proguard.annotation.Keep class * {*;}
-keep @proguard.annotation.KeepClassMembers class * {*;}
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
