#Current version 0.0.7

Write-Host "�������� ��������"
Write-Host "1 - ����������� ������ �������"
Write-Host "2 - ������������� ������ �������"
$Action = read-host

#���������� ����������
$Service1cName = "1C:Server"
$SqlServer = "apteka"
$SqlLogin = "sa"
$CurrentDate = Get-Date -Format _dd_MM_yyyy
Write-Host "������� ��� ���� ������ SQL"
    $SqlBase = Read-Host
Write-Host "������� ������ SQL �������"
    $SqlPassw = Read-Host

#�������
function SqlBackup {
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
        $SqlConnection.ConnectionString = "Server=$SqlServer; Database=$SqlBase; User ID=$SqlLogin; Password=$SqlPassw;"
        $SqlConnection.Open()
        $SqlCmd = $SqlConnection.CreateCommand()
        $SqlCmd.CommandText = "BACKUP DATABASE $SqlBase to disk = '$SqlBakPath$SqlBackupName.bac'"
        $objReader = $SqlCmd.ExecuteReader()
        while ($objReader.read()) {
  Write-Output $objReader.GetValue(0)
        }
        $objReader.close()

}
#���� ������� �����������.
if ($Action -eq 1) {
    Write-Host "������� ���� �� �������� � ������� ���������� ����������� ������ � �������."
    $Destination = Read-Host
    $IsPath = Test-Path $Destination
    if ($IsPath -eq "True") {
        $SqlBakPath = "$Destination\"
        Stop-Service $Service1cName
        $SqlBackupName = $SqlBase+$CurrentDate
        SqlBackup
        Copy-Item D:\mail $Destination\mail -Recurse -Container
        Copy-Item C:\Users\������������\AppData\Roaming\Psi+\profiles\default\history $Destination\history -Recurse -Container
        Copy-Item C:\Users\������������\Desktop $Destination\Desktop -Recurse -Container
    }
    else {
        Write-Host "�� ������ �������� �������, ���� ��� �������."
    }
}

#���� ������� �������������.
elseif ($Action -eq 2) {
    Write-Host "������� ���� �� �������� � �������� ���������� ����������� ������ �������."
    $Destination = Read-Host
    $IsPath = Test-Path $Destination
    if ($IsPath -eq "True") {
        Copy-Item $Destination\mail D:\mail  -Recurse -Container
        Copy-Item $Destination\history C:\Users\������������\AppData\Roaming\Psi+\profiles\default\history  -Recurse -Container
        Copy-Item $Destination\Desktop C:\Users\������������\Desktop -Recurse -Container
    }
    else {
        Write-Host "��� �����"
    }
}

#���� ������ ������ �������.
else {
    Write-Host "��� ���� ���������� 2 ��������, �� ������� ������. �� ���� ��� ����� �������."
}


