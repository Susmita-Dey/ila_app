package com.ila.health.mira_app

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Set this to true to enable the "Secure Screen" feature
        // This prevents screenshots and screen recording when the app is in background
        intent.putExtra("android.intent.extra.SECURE", true)
        super.onCreate(savedInstanceState)
    }
}
