@echo off
@reg copy HKLM\HARDWARE\ACPI\DSDT\VBOX__ HKLM\HARDWARE\ACPI\DSDT\NBOX__ /s /f
@reg delete HKLM\HARDWARE\ACPI\DSDT\VBOX__ /f
@reg add HKLM\HARDWARE\DESCRIPTION\System /v SystemBiosVersion /t REG_MULTI_SZ /d "NBOX   - 1" /f
@reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer" /t REG_SZ /d "9.11.22000.0" /f
@exit
