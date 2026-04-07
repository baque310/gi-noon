## Keep UCrop and OkHttp/Okio classes referenced during release minification
-keep class com.yalantis.ucrop.** { *; }
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

## Silence warnings for okhttp/okio if any
-dontwarn okhttp3.**
-dontwarn okio.**