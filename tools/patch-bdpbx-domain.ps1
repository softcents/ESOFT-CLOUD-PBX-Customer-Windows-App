$ErrorActionPreference = 'Stop'
$root = $env:GITHUB_WORKSPACE
if ([string]::IsNullOrWhiteSpace($root)) { $root = (Get-Location).Path }
$cppPath = Join-Path $root 'AccountDlg.cpp'
$rcPath = Join-Path $root 'res\dialog.rc2'
$cpp = [IO.File]::ReadAllText($cppPath)
$marker = 'static CString transportValues[] = {'
$helper = @(
'static const CString kESoftDomainSuffix = _T(".esoftbd.net");',
'',
'static CString ESofDisplayValue(const CString& value)',
'{',
'    CString v = value;',
'    v.Trim();',
'    int colon = v.Find(_T(":"));',
'    if (colon > 0) v = v.Left(colon);',
'    if (v.GetLength() >= kESoftDomainSuffix.GetLength() && v.Right(kESoftDomainSuffix.GetLength()).CompareNoCase(kESoftDomainSuffix) == 0) {',
'        v = v.Left(v.GetLength() - kESoftDomainSuffix.GetLength());',
'    } else {',
'        int dot = v.Find(_T("."));',
'        if (dot > 0) v = v.Left(dot);',
'    }',
'    return v;',
'}',
'',
'static CString ESofFullValue(const CString& value)',
'{',
'    CString v = ESofDisplayValue(value);',
'    if (v.IsEmpty()) return _T("");',
'    return v + kESoftDomainSuffix;',
'}',
''
) -join [Environment]::NewLine
if (-not $cpp.Contains('static const CString kESoftDomainSuffix')) {
    if (-not $cpp.Contains($marker)) { throw 'AccountDlg transport marker not found.' }
    $cpp = $cpp.Replace($marker, $helper + $marker)
}
$cpp = $cpp.Replace('edit->SetWindowText(m_Account.server);', 'edit->SetWindowText(ESofDisplayValue(m_Account.server));')
$cpp = $cpp.Replace('edit->SetWindowText(m_Account.proxy);', 'edit->SetWindowText(ESofDisplayValue(m_Account.proxy));')
$cpp = $cpp.Replace('edit->SetWindowText(m_Account.domain);', 'edit->SetWindowText(ESofDisplayValue(m_Account.domain));')
$cpp = $cpp.Replace('m_Account.server=str.Trim();', 'm_Account.server=ESofFullValue(str);')
$cpp = $cpp.Replace('m_Account.proxy=str.Trim();', 'm_Account.proxy=ESofFullValue(str);')
$cpp = $cpp.Replace('m_Account.domain=str.Trim();', 'm_Account.domain=ESofFullValue(str);')
[IO.File]::WriteAllText($cppPath, $cpp, [Text.UTF8Encoding]::new($false))
$rc = [IO.File]::ReadAllText($rcPath)
$controls = @(
    @{ id='IDC_EDIT_SERVER'; y='7'; labelY='10' },
    @{ id='IDC_EDIT_PROXY'; y='26'; labelY='29' },
    @{ id='IDC_EDIT_DOMAIN'; y='71'; labelY='74' }
)
foreach ($c in $controls) {
    $pattern = 'EDITTEXT\s+' + [regex]::Escape($c.id) + ',\s*86,\s*' + $c.y + '\s*\+\s*IDD_ACCOUNT_OFF_LABEL,\s*127\s*,\s*14,\s*ES_AUTOHSCROLL'
    $replacement = 'EDITTEXT        ' + $c.id + ', 86, ' + $c.y + ' + IDD_ACCOUNT_OFF_LABEL, 78, 14, ES_AUTOHSCROLL' + [Environment]::NewLine + 'LTEXT           ".esoftbd.net", IDC_STATIC, 166, ' + $c.labelY + ' + IDD_ACCOUNT_OFF_LABEL, 47, 8'
    $newRc = [regex]::Replace($rc, $pattern, $replacement, 1)
    if ($newRc -eq $rc) { throw ('Account domain resource block not found: ' + $c.id) }
    $rc = $newRc
}
[IO.File]::WriteAllText($rcPath, $rc, [Text.UTF8Encoding]::new($false))
Write-Host 'eSoft Cloud PBX fixed-domain UI/source patch applied: *.esoftbd.net'
