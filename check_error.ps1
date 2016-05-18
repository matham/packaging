function Check-Error
{
  param([int]$SuccessVal = 0)
  if ($SuccessVal -ne $LastExitCode) {
    throw "Failed with exit code $LastExitCode"
  }
}
