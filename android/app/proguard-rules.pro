# Proguard rules for PassKEY
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class androidx.lifecycle.** { *; }

# Keep secure storage classes
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep sqflite classes
-keep class com.tekartik.sqflite.** { *; }

# PointyCastle crypto
-keep class pointycastle.** { *; }
-dontwarn pointycastle.**
