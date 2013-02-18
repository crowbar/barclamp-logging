### Logging Barclamp API extensions

Barclamps are the core modulization for Crowbar.  For that reason, the API for barclamps is more limited because changes to barclamps can cause breaking changes to the framework.

#### Export

<table border=1>
<tr><th> Verb </th><th> URL </th><th> Options </th><th> Returns </th><th> Comments </th></tr>
  <tr><td> GET </td><td> /logging/v2/barclamps/export  </td><td> none  </td><td> creates logs as an artifact </td><td> - </td></tr> 
</table>

The Logging Barclamp supports the ability to consolidate and roll-up the logs in Crowbar using this API call.

To retrieve the logs, you must visit.... TBD