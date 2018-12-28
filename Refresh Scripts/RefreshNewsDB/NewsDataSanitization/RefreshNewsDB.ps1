# Create Prompt Box
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form 
$form.Text = "Refresh News Database"
$form.Size = New-Object System.Drawing.Size(320,200) 
$form.StartPosition = "CenterScreen"

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(50,100)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(175,100)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20) 
$label.Size = New-Object System.Drawing.Size(300,20) 
$label.Text = "Plese Enter Environment to Perform Database Refresh:  "
$form.Controls.Add($label) 

$textBox = New-Object System.Windows.Forms.TextBox 
$textBox.Location = New-Object System.Drawing.Point(20,60) 
$textBox.Size = New-Object System.Drawing.Size(260,20) 
$form.Controls.Add($textBox) 

$form.Topmost = $True

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()




if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $DatabaseName = $textBox.Text
       

    IF ($DatabaseName -eq 'Dev'){
    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS wordpress_dev;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database wordpress_dev;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_dev < "C:\wordpress.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_dev < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\Dev.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }
    ELSEIF ($DatabaseName -eq 'QA'){
    
    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS wordpress_qa;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database wordpress_qa;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_qa < "C:\wordpress.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_qa < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\QA.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }
    ELSEIF ($DatabaseName -eq 'Staging'){

    
    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS wordpress;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database wordpress;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress < "C:\wordpress.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\Staging.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }    
    
    ELSEIF ($DatabaseName -eq 'Apple'){

    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS wordpress_apple;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database wordpress_apple;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_apple < "C:\wordpress.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_apple < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\Apple.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }
    ELSEIF ($DatabaseName -eq 'Test'){

    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS test;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database test;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  test < "C:\wordpress.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  test < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\Test.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }

    ELSEIF ($DatabaseName -eq 'Dev-CN'){

    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS wordpress_cn_dev;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database wordpress_cn_dev;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_cn_dev < "C:\wordpress_cn.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_cn_dev < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\Dev_CN.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }
    ELSEIF ($DatabaseName -eq 'QA-CN'){

    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS wordpress_cn_qa;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database wordpress_cn_qa;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_cn_qa < "C:\wordpress_cn.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_cn_qa < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\QA_CN.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }
    ELSEIF ($DatabaseName -eq 'Staging-CN'){

    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS wordpress_cn;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database wordpress_cn;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_cn < "C:\wordpress_cn.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  wordpress_cn < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\Staging_CN.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }
    ELSEIF ($DatabaseName -eq 'Test-CN'){

    Write-Host "Dropping Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Drop database IF EXISTS test_cn;"' 
    Write-Host "Creating Database..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf" -e "Create database test_cn;"' 
    Write-Host "Importing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  test_cn < "C:\wordpress_cn.sql"' 
    Write-Host "Sanitizing Data..."
    cmd /C 'mysql --defaults-file="C:\Program Files\RefreshNewsDB\RefreshNewsDB.cnf"  test_cn < "C:\Program Files\RefreshNewsDB\NewsDataSanitization\Test_CN.sql"' 
    Write-Host "Database Refresh Complete!"
    pause

    }
    ELSE {
    echo 'Script not available for specified environment!'
    }

    
}

