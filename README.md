# JDownloader-Docker-SMTP
A couple scripts that allow for SMTP notifications from the JDownloader Docker image.

## Information
These scripts are intended to be used with the <a href="https://github.com/jlesage/docker-jdownloader-2">JDownloader Docker container by jlesage</a>.

In my case, these are running on an Ubuntu 24.04 VM with Docker Compose.

### Function
The `setup-msmtp` script is ran on startup, installing msmtp without the need for a custom Dockerfile.
When the package is finished inside of JDownloader, it calls `sendmail` and passes through variables, sending the notification email.

## Installation

### Download Files
Download `sendmail.sh` and `setup-msmtp.sh` from this repo and place them in the same directory as your `docker-compose.yml` file. Run `chmod +x` on each to ensure they can be run.

Enter the `sendmail` script and change the `RECIPIENT=` variable with the email address of your intended recipient.

### Configure msmtprc file
So your container knows what to use for msmtprc, you need to make a file that passes through the information you need to use.

Download the example `msmtprc` file from this repo and place it in the same directory as the other files, then fill it out with the information you need for your client:

```
account default
host mail.yourhost.com
port 587
from sender@yourhost.com
auth on
user sender@yourhost.com
password secure-password
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile /tmp/msmtp-test.log
```

### Configure docker-compose.yml
To add msmtp functionality, you need to add the following lines in your compose file's **volumes** section:

```
      - "./setup-msmtp.sh:/etc/cont-init.d/99-setup-msmtp.sh:ro"
      - "./sendmail.sh:/usr/local/bin/sendmail.sh"
      - "./msmtprc:/etc/msmtprc:ro"
```

### Configuring JDownloader
Navigate to your JDownloader container's address and enter **Settings** then **Extension Modules**.

Install the **Event Scripter** Extension and restart your container. You should now see a new **Event Scripter** tab at the bottom of the Settings scrollbar.

Enter Event Scripter and click **Add**. You can click to enter a name, and set the Trigger to **Package Finished**. Don't forget to click the checkmark on the left to enable the scripter.

Inside of the Script Editor, enter the following:

```
var name = package.getName();
var path = package.getDownloadFoler();
var message = name + "\n" path;
callAsync(function(){},"/usr/local/bin/sendmail.sh",[message]);
```

You can now test the script with the **Test Run** tab at the top of the window. If the `msmtp` file was configured correctly, the alert will be sent to the configured inbox.

Vertically expand the Script Editor window to expose the **Save** button and press it.

### Customizing email
You can customize the `sendmail.sh` to change the contents of the email to your liking.

### Troubleshooting
If the email fails to appear, ensure your msmtp credentials are correct and you included the recipient address inside of `sendmail.sh`.

Additional logs can be found inside the container with `docket exec -it jdownloader /bin/sh` as `msmtp-test.log`.
