#include "include/pip_video_player_linux/pip_video_player_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

const char kChannelName[] = "pip_video_player_linux";
const char kGetPlatformName[] = "getPlatformName";

struct _FlPipVideoPlayerPlugin {
  GObject parent_instance;

  FlPluginRegistrar* registrar;

  // Connection to Flutter engine.
  FlMethodChannel* channel;
};

G_DEFINE_TYPE(FlPipVideoPlayerPlugin, fl_pip_video_player_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  const gchar* method = fl_method_call_get_name(method_call);

  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(method, kGetPlatformName) == 0)
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_string("Linux")));
  else
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error))
    g_warning("Failed to send method call response: %s", error->message);
}

static void fl_pip_video_player_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(fl_pip_video_player_plugin_parent_class)->dispose(object);
}

static void fl_pip_video_player_plugin_class_init(FlPipVideoPlayerPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = fl_pip_video_player_plugin_dispose;
}

FlPipVideoPlayerPlugin* fl_pip_video_player_plugin_new(FlPluginRegistrar* registrar) {
  FlPipVideoPlayerPlugin* self = FL_PIP_VIDEO_PLAYER_PLUGIN(
      g_object_new(fl_pip_video_player_plugin_get_type(), nullptr));

  self->registrar = FL_PLUGIN_REGISTRAR(g_object_ref(registrar));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            kChannelName, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel, method_call_cb,
                                            g_object_ref(self), g_object_unref);

  return self;
}

static void fl_pip_video_player_plugin_init(FlPipVideoPlayerPlugin* self) {}

void pip_video_player_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlPipVideoPlayerPlugin* plugin = fl_pip_video_player_plugin_new(registrar);
  g_object_unref(plugin);
}
