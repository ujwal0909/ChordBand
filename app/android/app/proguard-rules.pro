# Proguard rules for ChordBand release
-keep class com.chordband.app.** { *; }

# Drift SQLite rules
-keep class * extends drift.GeneratedDatabase { *; }
-keepclassmembers class * extends drift.GeneratedDatabase { *; }

# Flutter Native
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
