package com.codeclinic.stockpathshala

import android.os.Bundle
import android.view.View
import androidx.core.view.WindowCompat
import com.ryanheise.audioservice.AudioServiceActivity
import com.ryanheise.audioservice.AudioServicePlugin

// Add these imports for auto-rotate detection
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings
import android.content.ContentResolver

class MainActivity : AudioServiceActivity() {

    // Add method channel constant
    private val CHANNEL = "system_settings_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // ✅ Enables edge-to-edge layout
        WindowCompat.setDecorFitsSystemWindows(window, false)

        // ✅ Force immersiveSticky mode natively
        hideSystemUI()
    }

    // Add this method to configure Flutter engine with method channel
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "checkAutoRotateToggle" -> {
                        checkAutoRotateStatus(result)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    // Add method to check auto-rotate status
    private fun checkAutoRotateStatus(result: MethodChannel.Result) {
        try {
            val contentResolver: ContentResolver = contentResolver
            val autoRotateEnabled = Settings.System.getInt(
                contentResolver,
                Settings.System.ACCELEROMETER_ROTATION,
                0
            ) == 1

            result.success(autoRotateEnabled)
        } catch (e: Settings.SettingNotFoundException) {
            result.error("SETTING_NOT_FOUND", "Auto-rotate setting not found", null)
        } catch (e: Exception) {
            result.error("ERROR", "Failed to check auto-rotate status: ${e.message}", null)
        }
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