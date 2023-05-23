# Contains a path to this script, relative to the directory it was called from.
RELATIVE_PATH_TO_SCRIPT="${BASH_SOURCE[0]}"

# The directory that this script is located in.
SCRIPT_DIR=`dirname "${RELATIVE_PATH_TO_SCRIPT}"`

pushd $SCRIPT_DIR

# Build the foo_devtools_plugin flutter web app
flutter clean
rm -rf build/web

flutter pub get
# Note: building in profile mode for easier debugging
flutter build web \
  --web-renderer canvaskit \
  --pwa-strategy=offline-first \
  --profile \
  --no-tree-shake-icons

# Ensure permissions are set correctly on canvaskit binaries.
chmod 0755 build/web/canvaskit/canvaskit.*

# Copy the plugin config into a temp folder so that we do not overwrite it.
mkdir _tmp
cp ../bin/devtools/plugin_config.json _tmp/plugin_config.json

# Empty the devtools extension directory in preparation for copying in the one we just built.
rm -rf ../bin/devtools/
mkdir ../bin/devtools

# Copy the build output of our foo_devtools_plugin flutter web app
cp -a build/web/. ../bin/devtools/

mv _tmp/plugin_config.json ../bin/devtools/plugin_config.json
rm -fr _tmp

popd