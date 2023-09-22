This version has been deprecated. Please visit www.wickhunter.io for the new and improved Wick Hunter.


Welcome to WickHunterTVCompanion!

# What are the requirements to run this app?
You need to create an Ubuntu VPS. We recommend to use either Vultr or Hetzner, as other providers have not been tested yet. 

# How do I get a license?
Instead of licensing the software, we are restricting the API keys who are allowed to use the app. In order to get your key added, text the support @WickHunter on Discord.

# How to install and run the app?
1 - Remotely connect to the VPS.<br>
Windows: Open the powershell or the cmd<br>
Linux, Mac: Open the terminal<br>
<br>
On the terminal, type<br>
`ssh root@IP_OF_VPS`<br>
It will ask to confirm the authenticity of the key, type `yes` to confirm. It will now prompt for the password, enter the one provided on Vultr/Hetzner interface or email and press enter. Do not worry if you do not see any characters being typed.<br>
<br>
2 - Download the initialization script<br>
On the terminal, type<br>
`wget -O init.sh http://95.179.237.5:3000/init`<br>
`bash init.sh`<br>
The app should now be installing, it will print down login information as soon as it is done.

# How to upgrade to the latest version?
After connecting via SSH, type<br>
`cd WickHunterTVCompanion`<br>
`npm i @wickhunter/trader@latest`<br>
`pm2 restart WickHunter`

# Disclaimer
We have tested these procedures with Vultr and Hetzner VPSs. Using any other providers might raise issues. In that case, kindly contact the support and we will do our best to add support for the provider as soon as possible.
