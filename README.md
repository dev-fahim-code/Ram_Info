# RAM Information Tool

A lightweight Windows Batch utility that collects and displays detailed RAM information using **PowerShell and WMI**.

## Features

* Displays installed physical RAM
* Shows usable, used, and free RAM
* Detects RAM module capacity
* Shows rated and running memory speed
* Displays manufacturer and part number
* Shows serial number when available
* Detects DDR, DDR2, DDR3, DDR4, and DDR5
* Displays DIMM/SODIMM form factor
* Shows RAM pin count
* Displays configured memory voltage
* Shows total, used, and free memory slots
* Automatically requests Administrator privileges

## Requirements

* Windows 10 or Windows 11
* PowerShell
* Administrator privileges

## Usage

1. Download or clone this repository.
2. Run the `.bat` file.
3. Accept the **User Account Control (UAC)** prompt.
4. The tool will generate and display your RAM information in the Command Prompt.

## Notes

Some hardware information, such as CAS Latency or certain voltage/SPD details, may not be available through Windows WMI. For more complete SPD information, tools such as CPU-Z may be required.

## Safety

This script is designed for system information and does not modify RAM settings or Windows configuration.

The script creates a temporary PowerShell file in the `%TEMP%` directory and removes it after execution.

Review the script before running it, especially when using modified or unofficial copies.

## License

This project is licensed under the **MIT License**.

You are free to use, copy, modify, merge, publish, distribute, sublicense, and sell copies of this software, subject to the conditions of the MIT License.

See the [`LICENSE`](LICENSE) file for the full license text.

## Disclaimer

This software is provided **"as is"**, without warranty of any kind. Use it at your own risk.
