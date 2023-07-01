package com.intileo.pip_widget


import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.graphics.Rect
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.util.Rational
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class NewFlutterActivity : FlutterActivity() {

    companion object{
        fun withNewEngine(): NewEngineIntentBuilder {
            return NewEngineIntentBuilder(NewFlutterActivity::class.java)
        }
    }
   }