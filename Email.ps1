# Storyline: Send an email.

# Variable can have an underscore or any alphanumeric value.

# Body of the email
$msg = "Hello there."

write-host -BackgroundColor Red -ForegroundColor white $msg

# Email From Address
$email = "sean.barrick@mymail.champlain.edu"

# To address
$toEmail = "deployer@csi-web"
Send-MailMessage -From $email -to $toEmail -Subject "A Greeting" -body $msg -SmtpServer 192.168.6.71