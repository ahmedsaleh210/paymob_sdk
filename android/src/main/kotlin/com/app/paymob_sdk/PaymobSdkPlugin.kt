package com.app.paymob_sdk

import android.app.Activity
import android.graphics.Color
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.paymob.paymob_sdk.PaymobSdk
import com.paymob.paymob_sdk.ui.PaymobSdkListener

/** PaymobSdkPlugin */
class PaymobSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PaymobSdkListener {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var SDKResult: Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "paymob/payment_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "payWithPaymob") {
            SDKResult = result
            callNativeSDK(call)
        } else {
            result.notImplemented()
        }
    }

    private fun callNativeSDK(call: MethodCall) {
        val currentActivity = activity ?: run {
            SDKResult?.error("NO_ACTIVITY", "Activity is null", null)
            return
        }

        val publicKey = call.argument<String>("publicKey")
        val clientSecret = call.argument<String>("clientSecret")
        val appName = call.argument<String>("appName")

        val buttonBackgroundColorData = call.argument<Number>("buttonBackgroundColor")?.toInt() ?: 0
        val buttonTextColorData = call.argument<Number>("buttonTextColor")?.toInt() ?: 0
        val saveCardDefault = call.argument<Boolean>("saveCardDefault") ?: false
        val showSaveCard = call.argument<Boolean>("showSaveCard") ?: true

        val buttonTextColor = Color.argb(
            (buttonTextColorData shr 24) and 0xFF,
            (buttonTextColorData shr 16) and 0xFF,
            (buttonTextColorData shr 8) and 0xFF,
            buttonTextColorData and 0xFF
        )

        val buttonBackgroundColor = Color.argb(
            (buttonBackgroundColorData shr 24) and 0xFF,
            (buttonBackgroundColorData shr 16) and 0xFF,
            (buttonBackgroundColorData shr 8) and 0xFF,
            buttonBackgroundColorData and 0xFF
        )

        Log.d("PaymobSdkPlugin", "buttonTextColor: $buttonTextColor")
        Log.d("PaymobSdkPlugin", "buttonBackgroundColor: $buttonBackgroundColor")

        val paymobSdk = PaymobSdk.Builder(
            context = currentActivity,
            clientSecret = clientSecret.toString(),
            publicKey = publicKey.toString(),
            paymobSdkListener = this,
        )
            .setButtonBackgroundColor(buttonBackgroundColor)
            .setButtonTextColor(buttonTextColor)
            .setAppName(appName)
            .showSaveCard(showSaveCard)
            .saveCardByDefault(saveCardDefault)
            .build()

        paymobSdk.start()
    }

    // PaymobSDK Return Values
    override fun onSuccess() {
        SDKResult?.success("Successfull")
    }

    override fun onFailure() {
        SDKResult?.success("Rejected")
    }

    override fun onPending() {
        SDKResult?.success("Pending")
    }

    // ActivityAware
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
