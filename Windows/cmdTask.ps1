# Get all scheduled tasks
$tasks = Get-ScheduledTask

# Loop through each task and check if any of its actions use PowerShell
$tasksWithCMD = foreach ($task in $tasks) {
    foreach ($action in $task.Actions) {
        if ($action.Execute -like "*cmd*") {
            [PSCustomObject]@{
                TaskName       = $task.TaskName
                TaskPath       = $task.TaskPath
                Action         = $action.Execute
                Arguments      = $action.Arguments
                LastRunTime    = $task.LastRunTime
                NextRunTime    = $task.NextRunTime
                Status         = $task.State
            }
        }
    }
}

# Display results
if ($tasksWithCMD) {
    $tasksWithCMD | Format-Table -AutoSize
} else {
    Write-Host "No tasks found that use CMD."
}