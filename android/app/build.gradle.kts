//import java.util.Properties
//import java.io.FileInputStream
//
//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//val localProperties = Properties()
//val localPropertiesFile = rootProject.file("local.properties")
//if (localPropertiesFile.exists()) {
//    localProperties.load(localPropertiesFile.inputStream())
//}
//
//val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
//val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"
//
//val keystoreProperties = Properties()
//val keystorePropertiesFile = rootProject.file("key.properties")
//if (keystorePropertiesFile.exists()) {
//    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
//}
//
//android {
//    namespace = "com.codeclinic.stockpathshala"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = "27.0.12077973" // ✅ Required NDK version
//
//    defaultConfig {
//        applicationId = "com.codeclinic.stockpathshala"
//        minSdk = 26
//        targetSdk = 35
//        versionCode = flutterVersionCode
//        versionName = flutterVersionName
//        multiDexEnabled = true
//        resConfigs("en", "en_US", "en_UK")
//
//        ndk {
//            debugSymbolLevel = "FULL"
//        }
//    }
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//        isCoreLibraryDesugaringEnabled = true // ✅ Required for desugaring
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    sourceSets["main"].java.srcDirs("src/main/kotlin")
//
//    bundle {
//        language {
//            enableSplit = false
//        }
//    }
//
//    splits {
//        abi {
//            isEnable = true
//            reset()
//            include("armeabi-v7a", "x86_64", "arm64-v8a")
//            isUniversalApk = true
//        }
//    }
//
//    signingConfigs {
//        create("release") {
//            val storeFilePath = keystoreProperties["storeFile"]?.toString()
//            val storePassword = keystoreProperties["storePassword"]?.toString()
//            val keyAlias = keystoreProperties["keyAlias"]?.toString()
//            val keyPassword = keystoreProperties["keyPassword"]?.toString()
//            if (storeFilePath == null || storePassword == null || keyAlias == null || keyPassword == null) {
//                throw GradleException("Missing keystore properties in key.properties")
//            }
//            storeFile = file(storeFilePath)
//            this.storePassword = storePassword
//            this.keyAlias = keyAlias
//            this.keyPassword = keyPassword
//        }
//    }
//
//    buildTypes {
//        getByName("release") {
//            signingConfig = signingConfigs.getByName("release")
//            isMinifyEnabled = true
//            isShrinkResources = true
//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt"),
//                "proguard-rules.pro"
//            )
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}
//
//dependencies {
//    implementation(platform("com.google.firebase:firebase-bom:31.2.3"))
//    implementation("com.google.firebase:firebase-analytics:21.3.0")
//    implementation("com.google.firebase:firebase-crashlytics:17.3.1")
//    implementation("com.google.firebase:firebase-messaging:20.1.0")
//    implementation("com.razorpay:checkout:1.6.14")
//    implementation("androidx.multidex:multidex:2.0.1")
//    implementation("com.google.android.exoplayer:exoplayer:2.18.1")
//    implementation("com.google.android.exoplayer:extension-ima:2.18.1")
//    implementation("com.google.android.gms:play-services-ads:21.3.0")
//
//    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
//}
//
import java.util.Properties
import java.io.FileInputStream
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// ✅ Load local.properties
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(localPropertiesFile.inputStream())
}

// ✅ Load versionCode and versionName from local.properties
val flutterVersionCode: Int = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val flutterVersionName: String = localProperties.getProperty("flutter.versionName") ?: "1.0.0"

// ✅ Load keystore for signing
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.codeclinic.stockpathshala"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.codeclinic.stockpathshala"
        minSdk = 26
        targetSdk = 35

        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
        resConfigs("en", "en_US", "en_UK")

        ndk {
            debugSymbolLevel = "FULL"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }
    sourceSets["main"].java.srcDirs("src/main/kotlin")

    bundle {
        language {
            enableSplit = false
        }
    }

    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "x86_64", "arm64-v8a")
            isUniversalApk = true
        }
    }
//    packagingOptions {
//        jniLibs {
//            useLegacyPackaging = true
//        }
//    }
    signingConfigs {
        create("release") {
            val storeFilePath = keystoreProperties["storeFile"]?.toString()
            val storePassword = keystoreProperties["storePassword"]?.toString()
            val keyAlias = keystoreProperties["keyAlias"]?.toString()
            val keyPassword = keystoreProperties["keyPassword"]?.toString()

            if (storeFilePath == null || storePassword == null || keyAlias == null || keyPassword == null) {
                throw GradleException("Missing keystore properties in key.properties")
            }
            storeFile = file(storeFilePath)
            this.storePassword = storePassword
            this.keyAlias = keyAlias
            this.keyPassword = keyPassword
        }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:31.2.3"))
    implementation("com.google.firebase:firebase-analytics:21.3.0")
    implementation("com.google.firebase:firebase-crashlytics:17.3.1")
    implementation("com.google.firebase:firebase-messaging:20.1.0")
    implementation("com.razorpay:checkout:1.6.14")
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("com.google.android.exoplayer:exoplayer:2.18.1")
    implementation("com.google.android.exoplayer:extension-ima:2.18.1")
    implementation("com.google.android.gms:play-services-ads:21.3.0")

    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
