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
import android.database.Cursor
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import androidx.core.content.ContextCompat

class MainActivity : FlutterActivity(){

    private val CHANNEL = "fake_call_log"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method )
            {
                "addFakeCallLog" -> {
                val name = call.argument<String>("name")
                val number = call.argument<String>("number")
                val type = call.argument<Int>("type") ?: CallLog.Calls.INCOMING_TYPE
                val duration = call.argument<Int>("duration") ?: 0
                val timestamp = call.argument<Long>("timestamp") ?: System.currentTimeMillis()
                
                val success = addFakeCallLog(number, name, type, duration, timestamp)
                result.success(success)
            }
                "queryCallLogs" -> {
                    queryLogs(result)
                }
                else -> result.notImplemented()
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

    private fun queryLogs( result: MethodChannel.Result) {
        val subscriptionManager = ContextCompat.getSystemService(this, SubscriptionManager::class.java)
        val subscriptions: List<SubscriptionInfo>? = subscriptionManager?.activeSubscriptionInfoList

        val callLogs = mutableListOf<Map<String, Any>>()
        val cursor: Cursor? = contentResolver.query(
            CallLog.Calls.CONTENT_URI,
            arrayOf(
                CallLog.Calls.NUMBER,
                CallLog.Calls.TYPE,
                CallLog.Calls.DATE,
                CallLog.Calls.DURATION,
                CallLog.Calls.CACHED_NAME,
                CallLog.Calls.PHONE_ACCOUNT_ID,
                CallLog.Calls.GEOCODED_LOCATION,
                CallLog.Calls.VOICEMAIL_URI,
                CallLog.Calls.IS_READ,
                CallLog.Calls.NEW,
                CallLog.Calls.POST_DIAL_DIGITS,
                CallLog.Calls.PHONE_ACCOUNT_COMPONENT_NAME,
                CallLog.Calls.PHONE_ACCOUNT_ID,
                CallLog.Calls.FEATURES,
                CallLog.Calls.DATA_USAGE,
                CallLog.Calls.TRANSCRIPTION
            ),
            null,
            null,
            "${CallLog.Calls.DATE} DESC"
        )

        cursor?.use {

            while (it.moveToNext()) {
                val callLog = mapOf(
                    "number" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.NUMBER)) ?: "Unknown"),
                    "callType" to it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.TYPE)),
                    "timestamp" to it.getLong(it.getColumnIndexOrThrow(CallLog.Calls.DATE)),
                    "duration" to it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.DURATION)),
                    "name" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.CACHED_NAME)) ?: "Unknown"),
                    "simDisplayName" to getSimDisplayName(subscriptions, it.getString(it.getColumnIndexOrThrow(CallLog.Calls.PHONE_ACCOUNT_ID))),
                    "phoneAccountId" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.PHONE_ACCOUNT_ID)) ?: "Unknown"),
                    "geocodedLocation" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.GEOCODED_LOCATION)) ?: "Unknown"),
                    "voicemailUri" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.VOICEMAIL_URI)) ?: ""),
                    "isRead" to it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.IS_READ)),
                    "isNew" to it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.NEW)),
                    "postDialDigits" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.POST_DIAL_DIGITS)) ?: ""),
                    "accountComponentName" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.PHONE_ACCOUNT_COMPONENT_NAME)) ?: ""),
                    "accountId" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.PHONE_ACCOUNT_ID)) ?: ""),
                    "features" to it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.FEATURES)),
                    "dataUsage" to it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.DATA_USAGE)),
                    "transcription" to (it.getString(it.getColumnIndexOrThrow(CallLog.Calls.TRANSCRIPTION)) ?: "")
                 )
                callLogs.add(callLog)
            }
        }

        if (callLogs.isNotEmpty()) {
            result.success(callLogs)
        } else {
            result.error("NO_CALL_LOGS", "No call logs found.", null)
        }
    }

    private fun getSimDisplayName(subscriptions: List<SubscriptionInfo>?, phoneAccountId: String?): String {
        subscriptions?.forEach {
            if (it.subscriptionId.toString() == phoneAccountId) {
                return it.displayName.toString()
            }
        }
        return "Unknown SIM"
    }
}
