plugins {
    id("com.android.application")
    // O Flutter Gradle Plugin deve vir logo após os plugins do Android
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.mobile"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Nome do aplicativo para o Android:
        manifestPlaceholders["appName"] = "MICROS"
    }

    buildTypes {
        release {
            // Configuração de assinatura para o build de release
            signingConfig = signingConfigs.getByName("debug")
            
            // Otimizações de build para release (desativadas por padrão até configurar ProGuard)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}