package com.xbr.fake_call_log

import io.flutter.embedding.android.FlutterActivity


import android.content.ContentValues
import android.content.pm.PackageManager
import android.os.Build
import android.provider.CallLog
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){

    private val CHANNEL = "fake_call_log"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "addFakeCallLog") {
                val name = call.argument<String>("name")
                val number = call.argument<String>("number")
                val type = call.argument<Int>("type") ?: CallLog.Calls.INCOMING_TYPE
                val duration = call.argument<Int>("duration") ?: 0
                val timestamp = call.argument<Long>("timestamp") ?: System.currentTimeMillis()
                
                val success = addFakeCallLog(number, name, type, duration, timestamp)
                result.success(success)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun addFakeCallLog(number: String?, name: String?, type: Int, duration: Int, timestamp: Long): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
            checkSelfPermission(android.Manifest.permission.WRITE_CALL_LOG) != PackageManager.PERMISSION_GRANTED) {
            return false
        }
        
        val values = ContentValues().apply {
            put(CallLog.Calls.NUMBER, number)
            put(CallLog.Calls.DATE, timestamp)
            put(CallLog.Calls.DURATION, duration)
            put(CallLog.Calls.TYPE, type)
            put(CallLog.Calls.NEW, 1)
            put(CallLog.Calls.CACHED_NAME, name)
        }

        val resolver = contentResolver
        return try {
            resolver.insert(CallLog.Calls.CONTENT_URI, values)
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
