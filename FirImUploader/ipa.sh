packaging(){

projectName=$1
scheme=$2
configuration=$3
workspace=$4
buildDir=$5
plistName=$6
date=$7

mkdir -p $buildDir
cd $workspace

xcodebuild archive \
-workspace "$projectName.xcworkspace" \
-scheme "$scheme" \
-configuration "$configuration" \
-archivePath "$buildDir/$projectName" \
clean \
build \
-derivedDataPath "$MWBuildTempDir"

xcodebuild -exportArchive \
-archivePath "$buildDir/$projectName.xcarchive" \
-exportPath "$buildDir/$projectName $date" \
-exportOptionsPlist "$workspace/$plistName"
}

# $1 工程名  $2 scheme 名字  $3 Release or Debug  $4 工程路径  $5 ipa 文件输出路径 $6 plist 文件名字
packaging $1 $2 $3 $4 $5 $6 $7
