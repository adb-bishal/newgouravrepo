##############################################
# ➤ FLUTTER ENGINE & PLUGINS
##############################################
-keep class io.flutter.embedding.android.FlutterActivity { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

##############################################
# ➤ FIREBASE (Messaging, Crashlytics, Analytics)
##############################################
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.crashlytics.** { *; }
-keep class com.google.firebase.analytics.** { *; }
-keep class com.google.firebase.components.** { *; }
-dontwarn com.google.firebase.**

##############################################
# ➤ GOOGLE PLAY SERVICES (Auth, Credentials API)
##############################################
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-keep class com.google.android.gms.common.api.GoogleApiClient { *; }
-keep class com.google.android.gms.tasks.** { *; }
-dontwarn com.google.android.gms.**

##############################################
# ➤ PLAY CORE (for deferred install / dynamic features)
##############################################
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.**

##############################################
# ➤ RAZORPAY (Only payment-related code kept)
##############################################
-keep class com.razorpay.Checkout { *; }
-keepclassmembers class * {
    public void onPaymentSuccess(java.lang.String);
    public void onPaymentError(int, java.lang.String);
}
-dontwarn com.razorpay.**

##############################################
# ➤ GSON / JSON MODEL SUPPORT
##############################################
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

##############################################
# ➤ MQTT (if using org.eclipse.paho)
##############################################
-dontwarn org.eclipse.paho.client.mqttv3.**
-keep class org.eclipse.paho.client.mqttv3.** { *; }

##############################################
# ➤ ANNOTATIONS, JNI, XML-Inflated Views
##############################################
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

##############################################
# ➤ AVOID UNNECESSARY WARNINGS
##############################################
-dontwarn android.support.v4.**
-dontwarn androidx.lifecycle.**
-dontwarn kotlinx.coroutines.**
-dontwarn com.google.protobuf.**

##############################################
# ➤ OPTIMIZATION FLAGS FOR SHRINKING
##############################################
-optimizations !code/simplification/arithmetic
-allowaccessmodification
-repackageclasses ''
-dontusemixedcaseclassnames
-keepattributes SourceFile,LineNumberTable

#-keep class * extends com.applozic.mobicommons.json.JsonMarker {
#    !static !transient <fields>;
#}
#-keepclassmembernames class * extends com.applozic.mobicommons.json.JsonParcelableMarker {
#    !static !transient <fields>;
#}
# ## Flutter wrapper
#-keep class io.flutter.app.* {  *; }
#-keep class io.flutter.plugin.* { *; }
#-keep class io.flutter.util.* {*; }
#-keep class io.flutter.view.* { *; }
#-keep class io.flutter.* { *; }
#-keep class io.flutter.plugins.* { *; }
#-keep class com.google.firebase.* { *; }
#-dontwarn io.flutter.embedding.**
#-ignorewarnings
##GSON Config
#-keepattributes Signature
#-keep class sun.misc.Unsafe { *; }
#-keep class androidx.autofill.** { *; }
#-keep class io.flutter.embedding.** { *; }
#-keep class io.flutter.plugin.** { *; }
#-keep class com.babariviere.sms.** { *; }
#-keep class com.google.gson.examples.android.model.** { *; }
#-keep class org.eclipse.paho.client.mqttv3.logging.JSR47Logger { *; }
#-keep class android.support.** { *; }
#-keep interface android.support.** { *; }
#-dontwarn android.support.v4.**
#-keep public class com.google.android.gms.* { public *; }
#-dontwarn com.google.android.gms.**
#-keep class com.google.gson.** { *; }
#-keepattributes *Annotation*
#-dontwarn com.razorpay.**
#-keep class com.razorpay.** {*;}
#-optimizations !method/inlining/
#-keepclasseswithmembers class * {
#  public void onPayment*(...);
#}
#
#Flutter Wrapper
#-keep class io.flutter.app.** { *; }
#-keep class io.flutter.plugin.**  { *; }
#-keep class io.flutter.util.**  { *; }
#-keep class io.flutter.view.**  { *; }
#-keep class io.flutter.**  { *; }
#-keep class io.flutter.plugins.**  { *; }
#-keep class io.flutter.plugin.editing.** { *; }
#
##Firebase
#-keep class com.google.firebase.** { *; }
#-keep class com.firebase.** { *; }
#-keep class org.apache.** { *; }
#-keepnames class com.fasterxml.jackson.** { *; }
#-keepnames class javax.servlet.** { *; }
#-keepnames class org.ietf.jgss.** { *; }
#-dontwarn org.w3c.dom.**
#-dontwarn org.joda.time.**
#-dontwarn org.shaded.apache.**
#-dontwarn org.ietf.jgss.**
#-keepattributes Signature
#-keepattributes *Annotation*
#-keepattributes EnclosingMethod
#-keepattributes InnerClasses
#-keep class androidx.lifecycle.DefaultLifecycleObserver
##Crashlytics
#-keepattributes SourceFile,LineNumberTable        # Keep file names and line numbers.
#-keep public class * extends java.lang.Exception
#-keep class com.example_app.** { *; }  # Unique App id
##twilio_programmable_video
#-keep class tvi.webrtc.** { *; }
#-keep class com.twilio.video.** { *; }
#-keep class com.twilio.common.** { *; }
#-keepattributes InnerClasses
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Prevent obfuscation of Flutter engine
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }