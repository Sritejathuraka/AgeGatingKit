package com.sritejathuraka.age_gating_kit

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import com.sritejathuraka.agegatingkit.AgeGating
import com.sritejathuraka.agegatingkit.models.AgeSignalsAccessResult

class AgeGatingKitPlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(
        flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "age_gating_kit"
        )

        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {

            "checkAge" -> {
                checkAge(result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun checkAge(
        flutterResult: MethodChannel.Result
    ) {
        val currentActivity = activity

        if (currentActivity == null) {
            flutterResult.error(
                "NO_ACTIVITY",
                "AgeGatingKit requires an Android Activity.",
                null
            )
            return
        }

        AgeGating.requestAgeSignalsAccess(
            activity = currentActivity,

            onSuccess = { accessResult ->

                when (accessResult) {

                    AgeSignalsAccessResult.SHARED -> {

                        AgeGating.checkAgeSignals(
                            activity = currentActivity,

                            onSuccess = { nativeResult ->

                                val lower =
                                    nativeResult.ageRange?.lowerBound

                                val upper =
                                    nativeResult.ageRange?.upperBound

                                val ageRange =
                                    when {
                                        lower != null && upper != null ->
                                            "$lower-$upper"

                                        lower != null ->
                                            "$lower+"

                                        else ->
                                            null
                                    }

                                flutterResult.success(
                                    mapOf(
                                        "isEligibleForAgeFeatures" to true,
                                        "ageRange" to ageRange,
                                        "requiredRegulatoryFeatures" to emptyList<String>()
                                    )
                                )
                            },

                            onFailure = { error ->
                                flutterResult.error(
                                    "CHECK_FAILED",
                                    error.message,
                                    null
                                )
                            }
                        )
                    }

                    AgeSignalsAccessResult.NOT_SHARED -> {
                        flutterResult.success(
                            mapOf(
                                "isEligibleForAgeFeatures" to false,
                                "ageRange" to null,
                                "requiredRegulatoryFeatures" to emptyList<String>()
                            )
                        )
                    }

                    AgeSignalsAccessResult.VERIFICATION_REQUIRED -> {
                        flutterResult.error(
                            "VERIFICATION_REQUIRED",
                            "Age verification is required.",
                            null
                        )
                    }

                    AgeSignalsAccessResult.UNSPECIFIED -> {
                        flutterResult.error(
                            "UNSPECIFIED",
                            "Age Signals returned an unspecified status.",
                            null
                        )
                    }
                }
            },

            onFailure = { error ->
                flutterResult.error(
                    "ACCESS_FAILED",
                    error.message,
                    null
                )
            }
        )
    }

    override fun onDetachedFromEngine(
        binding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(
        binding: ActivityPluginBinding
    ) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(
        binding: ActivityPluginBinding
    ) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}