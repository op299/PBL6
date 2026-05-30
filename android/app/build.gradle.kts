android {
    namespace = "com.example.pbl"
    // 1. Hạ compileSdk xuống 35 (bản 36 hiện tại quá mới, dễ lỗi với plugin)
    compileSdk = 35 
    
    // 2. Sửa lại ĐÚNG phiên bản NDK mà lỗi yêu cầu
    ndkVersion = "27.0.12077973" 

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.pbl"
        
        // 3. Sửa minSdk thành 21 (Bắt buộc để chạy được SQLite/sqflite)
        minSdk = 21 
        
        // 4. Khớp targetSdk với compileSdk
        targetSdk = 35 
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    // ... giữ nguyên phần còn lại
}