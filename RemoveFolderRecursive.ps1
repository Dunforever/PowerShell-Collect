$source="\\server\d$\folderparent" #location of directory to search
$strings=@("foldernametoremoveandallunderit")

cd ($source); get-childitem -Include ($strings) -Recurse -force | Remove-Item -Force –Recurse