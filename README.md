# Emergency Alerter
The popular emergency alerter app implemented for iOS.

# What does the app do?
This app allows you to select contacts who will be notified in case you get into an emergency situation. In such a scenario, you can either call an emergency number - the police for instance - or send out a text message with your current location to the predefined emergency contacts.

Because it might be difficult to press the emergency button in such a situation, it is also possible to activate the emergency process by shaking the smartphone.

Additionallly, the app shows you all police stations that are around your current position on a map.

# How can I use it?
It is possible to install the Emergency Alerter app on any iOS smartphone. For enhanced convenience, there is also an iWatch implementation, which could be useful in emergency situations since it might be easier to tap one button on the smart watch instead of the smartphone app. 

# Which permissions does the app need?
The app needs a few permissions in order to fulfil its task:
- for creating the list of emergency contacts, the app needs access to your smartphone's contact list.
- for notifying the emergency contacts, the app needs the permission to access your current location.
- for sending the emergency SMS messages, the app needs to be able to send text messages on your behalf.

Please be assured that your private data will not be used for anything else than to help you in an emergency situation.

# Is this thing really secure?
For retrieving the nearby police stations, the app uses an API backend service. The app sends your current location to the service, which determines all police stations within a 10 km radius and then returns them to the app. The communication is encrypted with HTTPS (Hypertext Transfer Protocol Secure), which means that nobody is able to read your location data except for the API service and the app itself.

# Who has developed this awesome app?
This app was developed by three students as part a university lecture.
- Florian Mayerhofer
- Michael Stifter
- Arlinda Butja
