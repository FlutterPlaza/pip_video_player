package com.flutterplaza.pipvideoplayer

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.Context
import android.net.Uri
import android.os.Build
import android.util.Rational
import androidx.annotation.NonNull
import androidx.media3.common.MediaItem
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.ui.PlayerView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

const val CHANNEL_NAME = "com.flutterplaza.pip_video_player"

enum class MethodEnums(val methodName: String) {
    GET_PLATFORM_NAME("getPlatformName"),
    PLAY_VIDEO("playVideo"),
    PAUSE_VIDEO("pauseVideo"),
    RESUME_VIDEO("resumeVideo"),
    STOP_VIDEO("stopVideo"),
    IS_PIP_MODE("isPipMode"),
    ENTER_PIP_MODE("enterPipMode"),
    EXIT_PIP_MODE("exitPipMode"),
    SEEK_TO("seekTo"),
    SEEK_FORWARD_15("seekForward15"),
    SEEK_BACKWARD_15("seekBackward15"),
    CLOSE_PIP("closePip")
}

class PipVideoPlayerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var exoPlayer: ExoPlayer
    private var playerView: PlayerView? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        exoPlayer = ExoPlayer.Builder(context).build()

        // Initialize PlayerView
        playerView = PlayerView(context).apply {
            player = exoPlayer
        }
    }

    private fun mapMethodCallToEnum(method: String): MethodEnums? {
        return MethodEnums.values().find { it.methodName == method }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (mapMethodCallToEnum(call.method)) {
            MethodEnums.GET_PLATFORM_NAME -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            MethodEnums.PLAY_VIDEO -> {
                val videoUrl = call.argument<String>("url")
                if (videoUrl != null) {
                    if (videoUrl.startsWith("asset://")) {
                        val assetPath = videoUrl.removePrefix("asset://")
                        playVideoFromAsset(assetPath)
                    } else {
                        playVideo(videoUrl)
                    }
                    result.success(null)
                }
            }
            MethodEnums.PAUSE_VIDEO -> {
                exoPlayer.pause()
                result.success(null)
            }
            MethodEnums.RESUME_VIDEO -> {
                exoPlayer.play()
                result.success(null)
            }
            MethodEnums.STOP_VIDEO -> {
                exoPlayer.stop()
                result.success(null)
            }
            MethodEnums.IS_PIP_MODE -> {
                result.success(isInPiPMode())
            }
            MethodEnums.ENTER_PIP_MODE -> {
                enterPiPMode()
                result.success(null)
            }
            MethodEnums.EXIT_PIP_MODE -> {
                exitPiPMode()
                result.success(null)
            }
            MethodEnums.SEEK_TO -> {
                val position = call.argument<Long>("position")
                if (position != null) {
                    exoPlayer.seekTo(position)
                    result.success(null)
                }
            }
            MethodEnums.SEEK_FORWARD_15 -> {
                seekForward15()
                result.success(null)
            }
            MethodEnums.SEEK_BACKWARD_15 -> {
                seekBackward15()
                result.success(null)
            }
            MethodEnums.CLOSE_PIP -> {
                closePiP()
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun playVideo(url: String) {
        val mediaItem = MediaItem.fromUri(Uri.parse(url))
        exoPlayer.setMediaItem(mediaItem)
        exoPlayer.prepare()
        exoPlayer.play()
    }

    private fun playVideoFromAsset(assetPath: String) {
        val assetUri = Uri.parse("asset:///$assetPath")
        val mediaItem = MediaItem.fromUri(assetUri)
        exoPlayer.setMediaItem(mediaItem)
        exoPlayer.prepare()
        exoPlayer.play()
    }

    private fun enterPiPMode() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val aspectRatio = Rational(playerView!!.width, playerView!!.height)
            val pipParams = PictureInPictureParams.Builder()
                .setAspectRatio(aspectRatio)
                .build()
            (context as? Activity)?.enterPictureInPictureMode(pipParams)
        }
    }

    private fun exitPiPMode() {
        // There's no direct exit PiP method, but you can detect the PiP mode and possibly bring the app to the foreground
        // or use a similar mechanism to end PiP mode.
        (context as? Activity)?.moveTaskToBack(false)
    }

    private fun isInPiPMode(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            (context as? Activity)?.isInPictureInPictureMode == true
        } else {
            TODO("VERSION.SDK_INT < N")
        }
    }

    private fun seekForward15() {
        val newPosition = exoPlayer.currentPosition + 15000
        exoPlayer.seekTo(newPosition)
    }

    private fun seekBackward15() {
        val newPosition = exoPlayer.currentPosition - 15000
        exoPlayer.seekTo(newPosition)
    }

    private fun closePiP() {
        if (isInPiPMode()) {
            (context as? Activity)?.finish()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        exoPlayer.release()
    }
}