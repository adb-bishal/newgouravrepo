//package com.codeclinic.stockpathshala
//
//import com.ryanheise.audioservice.AudioServiceActivity
//import com.ryanheise.audioservice.AudioServicePlugin
//
//import io.flutter.plugins.GeneratedPluginRegistrant
//
//
//class MainActivity: AudioServiceActivity() {
//
//    override fun onDestroy() {
//        AudioServicePlugin.disposeFlutterEngine()
//        super.onDestroy()
//    }
//}
package com.codeclinic.stockpathshala

import android.os.Bundle
import android.view.View
import androidx.core.view.WindowCompat
import com.ryanheise.audioservice.AudioServiceActivity
import com.ryanheise.audioservice.AudioServicePlugin

class MainActivity : AudioServiceActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // ✅ Enables edge-to-edge layout
        WindowCompat.setDecorFitsSystemWindows(window, false)

        // ✅ Force immersiveSticky mode natively
        hideSystemUI()
    }

    private fun hideSystemUI() {
        window.decorView.systemUiVisibility =
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
                    View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
                    View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
                    View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
                    View.SYSTEM_UI_FLAG_FULLSCREEN or
                    View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            hideSystemUI()
        }
    }

    override fun onDestroy() {
        AudioServicePlugin.disposeFlutterEngine()
        super.onDestroy()
    }
}

