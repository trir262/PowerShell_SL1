﻿Deploy Module {
    By PSGalleryModule {
        FromSource "C:\projects\powershell-sl1\ScienceLogic_SL1\Artifacts\ScienceLogic_SL1"
        To PSGallery
        WithOptions @{
            ApiKey = $Env:NugetApiKey
        }
    }
}