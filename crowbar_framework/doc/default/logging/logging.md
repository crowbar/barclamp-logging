## Logging Barclamp 

The Logging Barclamp provides based logging features for Crowbar.

It is considered to be a core barclamp and is installed and activated by default

### Logging Capabilities

The admin node serves as a central log repository. Its syslog daemon is configured to accept remote messages and each node is configured to forward all messages there.

### Exporting Logs

The Logging Barclamp extends the Support...Export UI by adding a button to export the system logs.  These logs may take a significant amount of time to compile.  When they are complete, they will appear on the Export list.
