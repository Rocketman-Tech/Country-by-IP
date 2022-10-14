# Country by IP
This script will retrieve the country that the device is in based on its external IP address. 

# History
We work with many global organizations, and when you have a completely automated Zero-Touch provisioning process in place, it's sometimes hard to tell where in the world the computer actually is. To solve this problem, we created the "Country by IP" Extension Attribute.

# How it Works
This Extension Attribute does an API call to Jamf to retrieve the computer's external IP address, and then runs an IP lookup to see what country it's coming from. 

Although this works well in most cases, if the computer is connected to VPN it can report in the wrong country. It gives us a good frame of reference, but we always take the results with a grain of salt. IP Addresses are not perfect indicators of location. 

# Deployment Instructions
This Extension Attribute must be deployed manually through Jamf by doing the following: 

1. API Account: Create an API User Account with the following permissions
   * Computers: Read
2. Create an API Encoded String for the Username/Password
   * Instructions: Created in Terminal using "echo -n 'username:password' | base64 | pbcopy"
   * Example: YXBpdXNlcm5hbWU6cGFzc3dvcmQK
3. Extension Attribute: Create an Extension Attributes in Jamf Pro with the following properties
   * Display Name: Country by IP
   * Data Type: String
   * Input Type: Script
   * Script Contents: Paste the contents of the **Country by IP.sh** script
   * **IMPORTANT**: Add the API Encoded String from step to to the **APIAUTH** variable 
