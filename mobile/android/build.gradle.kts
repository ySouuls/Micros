plugins {
    id("com.android.application") apply false
    id("com.android.library") apply false
    // Removido o plugin 'org.jetbrains.kotlin.android' que causava o erro no AGP 9+
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configuração atualizada do diretório de build
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}