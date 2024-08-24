# task_craft


## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```
---
## Project Structure 📁

```
├── lib
│   ├── app
│   │   ├── app.dart
│   │   ├── app_router.dart
├── core
│   ├── presentation
│   ├── utils
│   ├── config
│   ├── const
│   ├── widgets
├── l10n
├── modules
│   ├── module1
│   │   ├── data
│   │   ├── models
│   │   ├── repository
│   │   ├── service
│   ├── domain
│   │   ├── models
│   │   ├── repository
│   │   ├── bloc
│   ├── presentation
│   │   ├── widgets
│   │   ├── pages



```

## Change app Name 🏷️

```shell
flutter pub run flutter_app_name
```
**or**

### Linux
install `XMLStarlet`
```
sudo apt install xmlstarlet
```
install `GNUstep`
```
sudo apt install gnustep-base-runtime
```
Script
```shell
appName="Joruri"
declare -a androidAppTypes=(
    "main"
    "debug"
    "profile"
)

# Change app name for Android
for appType in ${androidAppTypes[@]}
do
    xmlstarlet ed -L -u '/manifest/application/@android:label' -v "$appName" android/app/src/$appType/AndroidManifest.xml
done

# Change app name for Android
plutil -replace CFBundleDisplayName -string "$appName" ios/Runner/Info.plist
```
## Change project name 🏷️

change flutter project name form `pubspac.yaml` and fix all import

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:app_with_very_good_cli/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

## Native Splash screen
`flutter_native_spalsh.yaml` file contains all the necessary config. under the hood, we are using [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
```shell
make createSplash
```

to setup proper splash screen [https://developer.android.com/develop/ui/views/launch/splash-screen](take a look here)