# Modern-Nomadic-Radio
It is a “sound board” prototype with Processing, Beads, ControlP5, and a text-to-speech library that implements the sound scheme for a modern context-aware version of the Nomadic Radio (NR) project

I designed my sound board with a wish to provide selective notifications to the users.
I disposed the buttons for call, email, message, voice mail, and twitter on top, and the four background environment sound buttons in image form to help intuitive perception. These buttons are in colored display when they are turned on and in grey color when they are turned off. All of the buttons also carry auditory icons.
Network and battery slides are disposed on the top right corner, and events buttons are put below them.
Memory button(toggle) is the least important in the sound board and thus located in the bottom right corner.


Overall, all of the priority 1 messages are always delivered the first. The priority 1 messages are stored in a special queue, and all the others are stored in an ordinary queue. When there is anything stored in the special queue, the message will be delivered first and then followed by anything in the ordinary queue.

When the user is lecturing, the user will be notified of only the priority 1 level calls, emails, text, and voice mails in vibration. The priority 1 level twitter is not notified since I believe that it can wait for one hour at least, and if someone wants to contact the user urgently, they would contact the user in the other ways but twitter in my opinion. I am trying not to distract the user in lecture, so the other priority level notifications will only be displayed on the screen.

When the user is in a party, the user would be engaged in conversation with friends, but still wants to be notified of some important messages in a scale not disturbing the conversation. Therefore, the system will notify the user of the priority level 1 and 2 calls, email, text, voice mails and priority level 1 twitter in sound(each type has its own earcon) and the others in vibration. Depending on the content, the pitch & length of the sound is adjusted.

For the jogging mode, every priority 1 messages in tts, and others in sound. Since the user is continuously moving(running), I believe that it is more effective to notify the user of any notifications in the auditory form than vibration. Also, the user should be cautious of the surrounding environments, and thus tts formed notifications are delivered only for the priority 1 level. Depending on the content, the pitch & length of the sound is adjusted.

When the user is in the transit mode, they user can enjoy interacting with the system. Thus, all of the priority 1 and 2 messages are delivered in tts; priority 1 messages will be notified as "important" and priority 2 messages will be notified as "new". Alsothe priority 3 and 4 messages are delivered in earcons. Depending on the content, the pitch & length of the sound is adjusted.

The battery function was designed using "Digital Chord" of garage band. The harmony, the pitch change, major chord & minor chord, and repetition of sound reperesent each battery level. The user will be notified of the battery status in between every 5 message.

The network was designed using the "Deep Chord" of garage band. The pitch difference will represent the network status. (high pitch good network, low pitch bad network) The user will be notified of the network status in between every 8 message.

The memory toggle(at the bottom right corner) provides the history of the overall record.
When you click it, it will notify you the number of missed call, emails, voice mails, text messages, twitters, and the total number of priority one messages. Then, it will play back the priority one messages in TTS.


The volume slide controls only the background sounds but other notification sounds; This will help the user to balance the background sounds and the notification sounds loudness.

To make the background sounds file, the following resources were used and combined using audacity and ocenaudio.

<Resources>
background http://www.freepik.com Designed by kjpargeter
jogging image https://www.verywellfit.com/tips-for-proper-running-form-4020227
transit image http://inagorillacostume.com/2011/vintage-train-guerrilla-marketing-york-boardwalk-empire/boardwalk-empire-vintage-nyc-subway-train-promo-2/
party image http://www.policemag.com/channel/patrol/articles/2016/05/house-party.aspx
lecture image https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&ved=2ahUKEwjUl__UiIzcAhVoRN8KHZNpADgQjhx6BAgBEAM&url=https%3A%2F%2Fwww.kent.ac.uk%2Fnews%2Fsociety%2F12531%2Fsky-news-economics-editor-gives-bob-friend-memorial-lecture&psig=AOvVaw13_tudwxTaGyfMio9k_79W&ust=1531021221624786

button images are edited and created by me using photoshop
my voice for lecturing
my breathe for running
mac typing https://freesound.org/s/413462/
person jogging https://freesound.org/s/407577/
train https://freesound.org/s/403083/
phone vibration https://freesound.org/s/401592/
messege notification https://freesound.org/s/400697/
party background chatter https://freesound.org/s/396684/
party background https://freesound.org/s/395315/
police sirens https://freesound.org/s/385867/
chime https://freesound.org/s/352661/
talk https://freesound.org/s/324265/
dingaling https://freesound.org/s/268756/
notification https://freesound.org/s/221359/
dog barking https://freesound.org/s/199261/
lecture hall https://freesound.org/s/182312/
car passing by https://freesound.org/s/171447/
conversation https://freesound.org/s/147514/
another notification https://freesound.org/s/132742/
pencil https://freesound.org/s/130462/
chair https://freesound.org/s/67239/
twitter notification https://www.youtube.com/watch?v=-nB59EVmizo
battery & network auditory icons were created by Garage band.
