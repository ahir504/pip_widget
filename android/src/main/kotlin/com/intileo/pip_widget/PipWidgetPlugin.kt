package com.intileo.pip_widget

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Rect
import android.os.Build
import android.util.Log
import android.util.Rational
import android.view.Window
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat.startActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PipWidgetPlugin */
class PipWidgetPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.intileo.pip_widget")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }


  @RequiresApi(Build.VERSION_CODES.O)
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "start_pip_activity" -> {
          val rouatName = call.arguments as String
          val args = listOf(rouatName)
          val intent = NewFlutterActivity.withNewEngine().dartEntrypointArgs(args).build(context)
//          val intent = Intent(context, NewFlutterActivity::class.java)
          intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
          context.startActivity(intent)
          result.success(true)
        }
        "pipAvailable" -> {
          result.success(
            activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
          )
        }
        "inPipAlready" -> {
          result.success(
            activity.isInPictureInPictureMode
          )
        }

      "enterPIP" -> {
        val pipParams = PictureInPictureParams.Builder()
        pipParams.setAspectRatio(
          Rational(
            call.argument("numerator") ?: 16,
            call.argument("denominator") ?: 9
          )
        )
        val sourceRectHintLTRB = call.argument<List<Int>>("sourceRectHintLTRB")
        if (sourceRectHintLTRB?.size == 4) {
          val bounds = Rect(
            sourceRectHintLTRB[0],
            sourceRectHintLTRB[1],
            sourceRectHintLTRB[2],
            sourceRectHintLTRB[3]
          )

          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            pipParams.setSourceRectHint(bounds)
          }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
          pipParams.setAutoEnterEnabled(true)
          pipParams.setSeamlessResizeEnabled(true)
        }
        result.success(
          activity.enterPictureInPictureMode(pipParams.build())

        )
      }
            "onBackPressed" -> {
        activity.finishAndRemoveTask()
      }
        else -> {
          result.error("1", "PiP Activity Is Not Launched", "to call this method first call launchPIPActivity() with arguments")
        }
    }
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {}

  @RequiresApi(Build.VERSION_CODES.N)
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    useBinding(binding)
  }

  @RequiresApi(Build.VERSION_CODES.N)
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    useBinding(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }


  @RequiresApi(Build.VERSION_CODES.N)
  fun useBinding(binding: ActivityPluginBinding) {
    activity = binding.activity
  }
}
