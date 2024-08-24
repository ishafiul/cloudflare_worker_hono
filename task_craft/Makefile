SHELL := /bin/bash

### Build Runner
buildRunner:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

### Change app icon
changeAppIcon:
	fvm flutter pub run flutter_launcher_icons

### Create Splash
createSplash:
	fvm flutter pub run flutter_native_splash:create --path=flutter_native_splash.yaml
	fvm flutter pub run flutter_native_splash:create --flavor production
	fvm flutter pub run flutter_native_splash:create --flavor development
	fvm flutter pub run flutter_native_splash:create --flavor staging

### Change app package name
changePackageName:
	fvm flutter pub run change_app_package_name:main com.example.ipp

### Build apk
apkBuildDev:
	fvm flutter build apk --flavor production --target lib/main_production.dart

### build aab app bundle
releaseBuild:
	fvm flutter build appbundle

newProjectSetup:
	flutter pub upgrade --major-versions

parseApi:
	powershell -Command "Remove-Item -Recurse -Force .\lib\api"
	fvm dart run swagger_parser swaggert_parser.yaml
