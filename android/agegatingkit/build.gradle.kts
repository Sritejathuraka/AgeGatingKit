plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.kotlin.android)
    id("maven-publish")
    id("signing")
}

android {
    namespace = "com.sritejathuraka.agegatingkit"
    compileSdk {
        version = release(36)
    }

    defaultConfig {
        minSdk = 23

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        consumerProguardFiles("consumer-rules.pro")
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    publishing {
        singleVariant("release") {
            withSourcesJar()
            withJavadocJar()

        }
    }
}

group = "io.github.sritejathuraka"
version = "0.1.0"

afterEvaluate {
    publishing {
        publications {
            create<MavenPublication>("release") {
                groupId = "io.github.sritejathuraka"
                artifactId = "agegatingkit"
                version = "0.1.0"
                from(components["release"])
                pom {
                    name.set("AgeGatingKit")
                    description.set(
                        "Open-source Android SDK for age assurance using Google Play Age Signals."
                    )
                    url.set(
                        "https://github.com/Sritejathuraka/AgeGatingKit"
                    )
                    licenses {
                        license {
                            name.set("MIT License")
                            url.set(
                                "https://opensource.org/licenses/MIT"
                            )
                        }
                    }
                    developers {
                        developer {
                            id.set("sritejathuraka")
                            name.set("Sriteja Thuraka")
                        }
                    }
                    scm {
                        connection.set(
                            "scm:git:git://github.com/Sritejathuraka/AgeGatingKit.git"
                        )
                        developerConnection.set(
                            "scm:git:ssh://github.com/Sritejathuraka/AgeGatingKit.git"
                        )
                        url.set(
                            "https://github.com/Sritejathuraka/AgeGatingKit"
                        )
                    }
                }
            }
        }
    }
    extensions.configure<SigningExtension> {
        val signingKeyFile =
            project.findProperty("signingKeyFile") as String
        val signingPassword =
            project.findProperty("signingPassword") as String
        val signingKey =
            file(signingKeyFile).readText()
        useInMemoryPgpKeys(
            signingKey,
            signingPassword
        )
        sign(
            publishing.publications["release"]
        )
    }
}


dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
    implementation("com.google.android.play:age-signals:0.0.4")
}