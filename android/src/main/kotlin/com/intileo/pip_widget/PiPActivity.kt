package com.intileo.pip_widget

import android.app.PictureInPictureParams
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Rect
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.util.Rational
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.annotation.RequiresApi
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import io.flutter.embedding.android.FlutterFragment

class PiPActivity : FragmentActivity(){
    companion object{
        private val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
    }

    private var flutterFragment: FlutterFragment? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val root = LinearLayout(this)
        root.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.MATCH_PARENT
        )
        root.orientation = LinearLayout.VERTICAL
        setContentView(root)

        val flutterContainer = FrameLayout(this)
        root.addView(flutterContainer)
        val containerId = 12345
        flutterContainer.id = containerId
        flutterContainer.layoutParams = LinearLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )

        val fragmentManager: FragmentManager = supportFragmentManager
        flutterFragment = fragmentManager
            .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?

        if (flutterFragment == null) {
            var newFlutterFragment = FlutterFragment
                .withNewEngine()
                .dartLibraryUri("package:test_widget/main.dart")
                .dartEntrypoint("pipActivity")
                .build<FlutterFragment>()
            flutterFragment = newFlutterFragment

            fragmentManager
                .beginTransaction()
                .add(
                    containerId,
                    newFlutterFragment,
                    TAG_FLUTTER_FRAGMENT
                ).commit()
        }
    }

    override fun onPostResume() {
        super.onPostResume()
        flutterFragment!!.onPostResume()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        flutterFragment!!.onNewIntent(intent)
    }

    override fun onBackPressed() {
        finish()
        flutterFragment!!.onBackPressed()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        flutterFragment!!.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        )
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onUserLeaveHint() {
        val aspectRatio =
            Rational(9, 16) // Set the desired aspect ratio for PiP mode
        val sourceRectHint = Rect(0, 0, 400, 300)
        val params = PictureInPictureParams.Builder()
        params.setAspectRatio(aspectRatio)
        params.setSourceRectHint(sourceRectHint)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            params.setAutoEnterEnabled(true)
            params.setSeamlessResizeEnabled(true)
        }
        enterPictureInPictureMode(params.build())
        flutterFragment!!.onUserLeaveHint()
    }

    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        flutterFragment!!.onTrimMemory(level)
    }


}