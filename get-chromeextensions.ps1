##: What server UNC path do you want to store audit files in
$servers = Get-Content -Path "C:\temp\host2.txt"
$auditfolderpath = "c:\temp\ChromeExtensions.txt"

ForEach ($server in $servers){ 
    #get all user dirs
    $user_folders = Get-ChildItem -Path "\\$($server)\C$\Users"
    ForEach ($userFolder in $user_folders){
        #get extension folders
        if (Test-Path -Path "$($userFolder.FullName)\AppData\Local\Google\Chrome\User Data\Default\Extensions"){
            $extension_folders = Get-ChildItem -Path "$($userFolder.FullName)\AppData\Local\Google\Chrome\User Data\Default\Extensions"
            #loop trhough each extension folder
            ForEach ($extension_folder in $extension_folders){
                $version_folders = Get-ChildItem -Path "$($extension_folder.FullName)"
                foreach ($version_folder in $version_folders) {
                    ##: The extension folder name is the app id in the Chrome web store
                    $appid = $extension_folder.BaseName

                    ##: First check the manifest for a name
                    $json = Get-Content -Raw -Path "$($version_folder.FullName)\manifest.json" | ConvertFrom-Json
                    $name = $json.name

                    ##: If we find _MSG_ in the manifest it's probably an app
                    if( $name -like "*MSG*" ) {
                        ##: Sometimes the folder is en
                        if( Test-Path -Path "$($version_folder.FullName)\_locales\en\messages.json" ) {
                            $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en\messages.json" | ConvertFrom-Json
                            $name = $json.appName.message
                            if(!$name) {
                                $name = $json.extName.message
                            }
                            if(!$name) {
                                $name = $json.app_name.message
                            }
                        }
                        ##: Sometimes the folder is en_US
                        if( Test-Path -Path "$($version_folder.FullName)\_locales\en_US\messages.json" ) {
                            $json = Get-Content -Raw -Path "$($version_folder.FullName)\_locales\en_US\messages.json" | ConvertFrom-Json
                            $name = $json.appName.message
                            if(!$name) {
                                $name = $json.extName.message
                            }
                            if(!$name) {
                                $name = $json.app_name.message
                            }
                        }
                        
                    }
                    echo "$($userFolder.FullName),$($name),$($version_folder)" | Out-File -Append $auditfolderpath
                }
            }
            
        }
        echo "$($userFolder.FullName) - No Chrome Extensions" | Out-File -Append $auditfolderpath

    }
}