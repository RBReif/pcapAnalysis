# pcapAnalysis, mitmdump and Certificate Pinning analysis
This repository contains scripts to start Wireshark at Windows via a WSL2 Subsystem and capturing and storing traffic for later analysis (e.g. of certificate pinning). 
This is performed two times. 
The second time mitmdump is started on Windows.
Afterwards captured logs are analyzed to detect first and third party Certificate Pinning.
This is partly developed for a project for a Cryptography course (INSE6110 @Concordia). 

Captured .pcap Files can be analysed e.g. as described in https://dl.acm.org/doi/10.1145/3517745.3561439
