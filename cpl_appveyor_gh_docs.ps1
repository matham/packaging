function Check-Error
{
  param([int]$SuccessVal = 0)
  if ($SuccessVal -ne $LastExitCode) {
    throw "Failed with exit code $LastExitCode"
  }
}

if ($env:APPVEYOR_REPO_BRANCH -eq "master" -and -not $env:APPVEYOR_PULL_REQUEST_NUMBER) {
  cd "$env:APPVEYOR_BUILD_FOLDER"
  python -m pip install sphinx
  Check-Error
  cd doc
  ./make.bat html
  Check-Error
  ./make.bat html
  Check-Error
  cd ..
  mkdir "C:\docs_temp"
  Copy-Item "doc\build\html\*" "C:\docs_temp" -recurse
  Check-Error

  git config --global credential.helper store
  Add-Content "$env:USERPROFILE\.git-credentials" "https://$($env:access_token):x-oauth-basic@github.com`n"
  git config --global user.email "moiein2000@gmail.com"
  git config --global user.name "Matthew Einhorn"
  Check-Error

  git checkout --orphan gh-pages
  Check-Error
  git rm -rf .
  Remove-Item -recurse * -exclude .git
  Copy-Item "C:\docs_temp\*" .  -recurse
  echo "" > .nojekyll

  git add .
  Check-Error
  git commit -a -m "Docs for git-$env:APPVEYOR_REPO_COMMIT"
  Check-Error
  git push origin gh-pages -f
  Check-Error
}
